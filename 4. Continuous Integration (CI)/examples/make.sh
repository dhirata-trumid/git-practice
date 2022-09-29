#!/bin/bash
set -euxo pipefail

# this runs in a subshell so we don't mess up your env vars
main () (
    # https://omnistac.jfrog.io credentials move around from box to box so we try to do
    # our best to figure out what they are and put them in one place for this script
    export TM_PIP_USER=${TM_PIP_USER:-${JFROG_UPLOADER_CREDS_USR:-${TM_PIP_RO_USER:-${JFROG_DOCKER_CREDS_USR:-}}}}
    export TM_PIP_PASS=${TM_PIP_PASS:-${JFROG_UPLOADER_CREDS_PSW:-${TM_PIP_RO_PASS:-${JFROG_DOCKER_CREDS_PSW:-}}}}
    export IMAGE=${IMAGE:-omnistac-docker-local.jfrog.io/omnistac/labs/favemap}
    export SUPPORT_IMAGE=${SUPPORT_IMAGE:-omnistac-docker-local.jfrog.io/omnistac/labs/favemap_support}
    export BRANCH=${BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
    local SUB_CMD=$1
    shift 1

    case $SUB_CMD in

        install)
            if which poetry
            then
                poetry install
            else
                # first time setup, install poetry and add repo credentials
                pip install --upgrade poetry
                poetry config http-basic.jfrog ${TM_PIP_USER:?"need to set a TM_PIP_USER"} ${TM_PIP_PASS:?"need to set a TM_PIP_PASS"}
            fi
            ;;

        build)
            [ -z "$TM_PIP_USER" ] && echo "TM_PIP_USER can't be empty" && false
            [ -z "$TM_PIP_PASS" ] && echo "TM_PIP_PASS can't be empty" && false
            export TAG=${TAG:-${1}}
            docker-compose -f prod-docker-compose.yml build calc_worker
            docker-compose build testing
            # set -euxo will fail the script if this doesn't have a default, empty
            # string still fails the if check though
            if [ -n "${PIPELINE_VERSION:-}" ]
            then
                docker tag ${IMAGE}:${TAG} ${IMAGE}:${PIPELINE_VERSION}
            fi
            ;;

        build_support)
            export TAG=${TAG:-${1}}
            docker-compose -f prod-docker-compose.yml build favemap_support
            # set -euxo will fail the script if this doesn't have a default, empty
            # string still fails the if check though
            if [ -n "${PIPELINE_VERSION:-}" ]
            then
                docker tag ${SUPPORT_IMAGE}:${TAG} ${SUPPORT_IMAGE}:${PIPELINE_VERSION}
            fi
            ;;

        tbash)
            [ -z "$TM_PIP_USER" ] && echo "TM_PIP_USER can't be empty" && false
            [ -z "$TM_PIP_PASS" ] && echo "TM_PIP_PASS can't be empty" && false
            export TAG=${TAG:-${1}}
            export VAULT_TOKEN=${VAULT_TOKEN?need vault token}
            docker-compose -f docker-compose.yml \
                run -v $(pwd):/opt/favemap \
                testing bash
            ;;

        test)
            [ -z "$TM_PIP_USER" ] && echo "TM_PIP_USER can't be empty" && false
            [ -z "$TM_PIP_PASS" ] && echo "TM_PIP_PASS can't be empty" && false
            export TAG=${TAG:-${1}}
            export VAULT_TOKEN=${VAULT_TOKEN?need vault token}
            docker-compose -f docker-compose.yml \
                run -v $(pwd):/opt/favemap \
                testing py.test /opt/favemap/t -vv
            docker-compose -f docker-compose.yml \
                run -v $(pwd):/opt/favemap \
                testing behave /opt/favemap/tests --stop
            ;;

        test-ci)
            [ -z "$TM_PIP_USER" ] && echo "TM_PIP_USER can't be empty" && false
            [ -z "$TM_PIP_PASS" ] && echo "TM_PIP_PASS can't be empty" && false
            export TAG=${TAG:-${1}}
            export VAULT_TOKEN=${VAULT_TOKEN?need vault token}
            export VAULT_ADDR=${VAULT_ADDR:-"http://172.31.21.116:8200"}
            if ! [ -x "$(command -v vault)" ]
            then
                curl -LO https://releases.hashicorp.com/vault/1.4.2/vault_1.4.2_linux_amd64.zip
                unzip -o vault_1.4.2_linux_amd64.zip
                rm vault_1.4.2_linux_amd64.zip
                export PATH=$(pwd):$PATH
            fi
            # don't want to spill secrets
            set +x
            [ -z "${AWS_ACCESS_KEY_ID:-}" ] && export AWS_ACCESS_KEY_ID=$(vault kv get -field=aws_access_key_id kv-v2/labs/test/favemap/config)
            [ -z "${AWS_SECRET_ACCESS_KEY:-}" ] && export AWS_SECRET_ACCESS_KEY=$(vault kv get -field=aws_secret_access_key kv-v2/labs/test/favemap/config)
            set -x
            set +e
            docker-compose -f docker-compose.yml \
                run --name=favemap-pytest testing \
                py.test /opt/favemap/t -vv --junitxml=/test_results/test_results.xml
            local RET1=$?
            docker cp favemap-pytest:/test_results/. $(pwd)/test_results
            docker rm favemap-pytest

            docker-compose -f docker-compose.yml \
                run --name=favemap-behave testing \
                behave /opt/favemap/tests --junit --junit-directory /test_results/
            local RET2=$?
            docker cp favemap-behave:/test_results/. $(pwd)/test_results
            docker rm favemap-behave

            docker-compose -f docker-compose.yml down

            set -e
            if [ $RET1 -ne 0 ]; then
                exit $RET1
            fi
            if [ $RET2 -ne 0 ]; then
                exit $RET2
            fi
            ;;

        test-pytest)
            [ -z "$TM_PIP_USER" ] && echo "TM_PIP_USER can't be empty" && false
            [ -z "$TM_PIP_PASS" ] && echo "TM_PIP_PASS can't be empty" && false
            export TAG=${TAG:-${1}}
            export VAULT_TOKEN=${VAULT_TOKEN?need vault token}
            export VAULT_ADDR=${VAULT_ADDR:-"http://172.31.21.116:8200"}
            if ! [ -x "$(command -v vault)" ]
            then
                curl -LO https://releases.hashicorp.com/vault/1.4.2/vault_1.4.2_linux_amd64.zip
                unzip -o vault_1.4.2_linux_amd64.zip
                rm vault_1.4.2_linux_amd64.zip
                export PATH=$(pwd):$PATH
            fi
            # don't want to spill secrets
            set +x
            [ -z "${AWS_ACCESS_KEY_ID:-}" ] && export AWS_ACCESS_KEY_ID=$(vault kv get -field=aws_access_key_id kv-v2/labs/test/favemap/config)
            [ -z "${AWS_SECRET_ACCESS_KEY:-}" ] && export AWS_SECRET_ACCESS_KEY=$(vault kv get -field=aws_secret_access_key kv-v2/labs/test/favemap/config)
            set -x
            set +e
            docker-compose -f docker-compose.yml \
                run -v $(pwd)/test_results:/test_results testing \
                py.test /opt/favemap/t -s -vv --junitxml=/test_results/test_results.xml
            local RET1=$?
            docker-compose -f docker-compose.yml down
            set -e
            if [ $RET1 -ne 0 ]; then
                exit $RET1
            fi
            ;;

        test-behave)
            [ -z "$TM_PIP_USER" ] && echo "TM_PIP_USER can't be empty" && false
            [ -z "$TM_PIP_PASS" ] && echo "TM_PIP_PASS can't be empty" && false
            export TAG=${TAG:-${1}}
            export VAULT_TOKEN=${VAULT_TOKEN?need vault token}
            export VAULT_ADDR=${VAULT_ADDR:-"http://172.31.21.116:8200"}
            if ! [ -x "$(command -v vault)" ]
            then
                curl -LO https://releases.hashicorp.com/vault/1.4.2/vault_1.4.2_linux_amd64.zip
                unzip -o vault_1.4.2_linux_amd64.zip
                rm vault_1.4.2_linux_amd64.zip
                export PATH=$(pwd):$PATH
            fi
            # don't want to spill secrets
            set +x
            [ -z "${AWS_ACCESS_KEY_ID:-}" ] && export AWS_ACCESS_KEY_ID=$(vault kv get -field=aws_access_key_id kv-v2/labs/test/favemap/config)
            [ -z "${AWS_SECRET_ACCESS_KEY:-}" ] && export AWS_SECRET_ACCESS_KEY=$(vault kv get -field=aws_secret_access_key kv-v2/labs/test/favemap/config)
            set -x
            set +e
            docker-compose -f docker-compose.yml \
                run -v $(pwd)/test_results:/test_results -v $(pwd)/tests:/opt/favemap/tests testing \
                behave /opt/favemap/tests --junit --junit-directory /test_results/
            local RET1=$?
            docker-compose -f docker-compose.yml down
            set -e
            if [ $RET1 -ne 0 ]; then
                exit $RET1
            fi
            ;;

        push)
            export TAG=${TAG:-${1}}
            docker push ${IMAGE}:${TAG}
            # set -euxo will fail the script if this doesn't have a default, empty
            # string still fails the if check though
            if [ -n "${PIPELINE_VERSION:-}" ]
            then
                docker push ${IMAGE}:${PIPELINE_VERSION}
            fi
            ;;

        push_support)
            export TAG=${TAG:-${1}}
            docker push ${SUPPORT_IMAGE}:${TAG}
            # set -euxo will fail the script if this doesn't have a default, empty
            # string still fails the if check though
            if [ -n "${PIPELINE_VERSION:-}" ]
            then
                docker push ${SUPPORT_IMAGE}:${PIPELINE_VERSION}
            fi
            ;;


        publish)
            [ -z "$TM_PIP_USER" ] && echo "TM_PIP_USER can't be empty" && false
            [ -z "$TM_PIP_PASS" ] && echo "TM_PIP_PASS can't be empty" && false
            export TAG=${TAG:-${1}}
            if [ -n "$BRANCH" ] && [ "$BRANCH" != "HEAD" ]
            then
                docker tag ${IMAGE}:${TAG} ${IMAGE}:${BRANCH}
                docker push ${IMAGE}:${BRANCH}
            fi

            docker run --rm \
                -v $(pwd):/opt/labs-python \
                -w /opt/labs-python \
                omnistac-docker-local.jfrog.io/omnistac/labs/skeleton:0.1.12 \
                poetry build
            docker run --rm \
                -v $(pwd):/opt/labs-python \
                -v $(pwd)/.config:/root/.config \
                -w /opt/labs-python \
                omnistac-docker-local.jfrog.io/omnistac/labs/skeleton:0.1.12 \
                poetry publish -r local -u ${TM_PIP_USER} -p ${TM_PIP_PASS}
            ;;

        clean)
            docker system prune -f --volumes
            ;;

        bash)
            [ -z "$TM_PIP_USER" ] && echo "TM_PIP_USER can't be empty" && false
            [ -z "$TM_PIP_PASS" ] && echo "TM_PIP_PASS can't be empty" && false
            export TAG=${TAG:-${1}}
            docker-compose -f local-docker-compose.yml run calc_worker bash
            ;;
        up)
            [ -z "$TM_PIP_USER" ] && echo "TM_PIP_USER can't be empty" && false
            [ -z "$TM_PIP_PASS" ] && echo "TM_PIP_PASS can't be empty" && false
            export TAG=${TAG:-${1}}
            export VAULT_TOKEN=${VAULT_TOKEN?need vault token}
            docker-compose -f local-docker-compose.yml up \
                --scale calc_worker=${NUM_CALC_WORKER:-1} \
                --scale confidence_scorer=${NUM_CONFIDENCE_SCORER:-1} \
                --scale bid_offer_enricher=${NUM_BID_OFFER_ENRICHER:-1} \
                --scale instrument_state_enricher=${NUM_INSTRUMENT_STATE_ENRICHER:-1}
            ;;
        deploy)
            export TAG=${PIPELINE_VERSION}
            export FAVEMAP_LOG_DIR=${FAVEMAP_LOG_DIR:-~/favemap}
            export VAULT_TOKEN=${VAULT_TOKEN?need vault token}
            docker-compose -p favemap -f prod-docker-compose.yml pull calc_worker favemap_support
            docker-compose -p favemap -f prod-docker-compose.yml down
            docker-compose -p favemap -f prod-docker-compose.yml up -d \
                --scale calc_worker=${NUM_CALC_WORKER:-12} \
                --scale confidence_scorer=${NUM_CONFIDENCE_SCORER:-16} \
                --scale bid_offer_enricher=${NUM_BID_OFFER_ENRICHER:-8} \
                --scale instrument_state_enricher=${NUM_INSTRUMENT_STATE_ENRICHER:-16}
            ;;
        deploy_rmq)
            docker-compose -p favemap_infra -f local-docker-compose.yml pull rabbitmq
            docker-compose -p favemap_infra -f local-docker-compose.yml up -d rabbitmq
            ;;
        version)
            export TAG=${TAG:-${1}}
            echo $TAG
            ;;
        bump)
            bumpversion ${1:-patch}
            ;;
        rc)
            # if the current version is not a release candidate bump the version a patch
            # and add a -rc0 suffix, if it is already an rc increment the rc number
            local CUR_V=$(grep 'current_version =' .bumpversion.cfg | cut -d'=' -f2)
            local CUR_RC=$(echo $CUR_V | cut -d'-' -f2)
            if [ -z "$CUR_RC" ]
            then
                local OLD_V=$(bumpversion ${1:-patch} --no-commit --no-tag --list | head -n 1 | cut -d= -f2)
                bumpversion rc --allow-dirty --message "Bump Version: $OLD_V -> {new_version}"
            else
                bumpversion rc
            fi

            ;;
        release)
            # promote a release candidate to a release
            local CUR_V=$(grep 'current_version =' .bumpversion.cfg | cut -d'=' -f2)
            local CUR_RC=$(echo $CUR_V | cut -d'-' -f2)
            if [ -z "$CUR_RC" ]
            then
                echo "not a release candidate"
                exit 1
            else
                bumpversion rc --serialize '{major}.{minor}.{patch}'
            fi

            ;;
        *)
            echo "ERROR: unknown parameter $SUB_CMD" && false
            ;;
    esac
)

main $@

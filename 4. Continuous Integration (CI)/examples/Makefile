IMAGE ?= omnistac-docker-local.jfrog.io/omnistac/labs/favemap
FAVEMAP_LOG_DIR ?= $$HOME/favemap/
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
TAG ?= "0.1.6"


install:
	$(ROOT_DIR)/make.sh install

build:
	$(ROOT_DIR)/make.sh build $(TAG)

build_support:
	$(ROOT_DIR)/make.sh build_support $(TAG)

tbash:
	$(ROOT_DIR)/make.sh tbash $(TAG)

test:
	$(ROOT_DIR)/make.sh test $(TAG)

test-ci:
	$(ROOT_DIR)/make.sh test-ci $(TAG)

test-pytest:
	$(ROOT_DIR)/make.sh test-pytest $(TAG)

test-behave:
	$(ROOT_DIR)/make.sh test-behave $(TAG)

rtest:
	$(ROOT_DIR)/make.sh rtest $(TAG)

push:
	$(ROOT_DIR)/make.sh push $(TAG)

push_support:
	$(ROOT_DIR)/make.sh push_support $(TAG)

publish:
	$(ROOT_DIR)/make.sh publish $(TAG)

clean:
	$(ROOT_DIR)/make.sh clean

bash:
	$(ROOT_DIR)/make.sh bash $(TAG)

up:
	$(ROOT_DIR)/make.sh up $(TAG)

deploy:
	$(ROOT_DIR)/make.sh deploy

deploy_rmq:
	$(ROOT_DIR)/make.sh deploy_rmq

bump:
	$(ROOT_DIR)/make.sh bump

rc:
	$(ROOT_DIR)/make.sh rc

release:
	$(ROOT_DIR)/make.sh release

env-file:
	$(ROOT_DIR)/make.sh env-file

stop:
	env WORKSPACE=$(WORKSPACE) \
		ansible-playbook ansible/cleanup_apps.yml

version:
	$(ROOT_DIR)/make.sh version $(PYPI_VERSION)

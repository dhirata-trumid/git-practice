# Continuous Integration (CI)

In this lesson we'll talk about

* What continuous integration is
* How CI works and when it runs
* How to figure out what commands CI is running in a typical Labs repo


## What is continuous integration?

Continuous integration can mean a lot different things to different people. At Trumid, it refers to the process which automatically:
* runs tests
* builds our code
* deploys ourc ode 

For the purporses of this git focused lesson, we'll be more focused on the portion of CI that runs our tests, since that's really where git and CI intersect.

## How does CI work and when does it run?

At Trumid, we use a tool called Jenkins to run our CI. You don't need to know much about it, just that it can be set up to run arbitrary scripts on a schedule, from external triggers, or on an adhoc basis.

The typical process of what happens is:
1. We create a new job in Jenkins 
2. We configure that job so that it runs whenever:
    * there are updates to a branch in the repo
    * there are updates to a pull request (PR) in the repo
3. The Jenkins job looks for something called a `Jenkinsfile` to figure out what commands to actually run. The Jenkinsfile needs to be in the top level of your git repo 
4. You can view currently running and past CI jobs at [Jenkins CI](ci.ad.trumid.com)
5. For PRs, the job results are communicated back to github. The usual options are "passed", "failed", or "running"
6. We can then configure the github repo to not allow merges to master unless the CI job has pssed.

## How to figure out what commands CI is running

The `Jenkinsfile` is the first place you should go to figure out what commands CI is running. The `examples` directory shows a typical example of what this looks like (see [here](examples/Jenkinsfile)). The important part to focus on is the section labeled `stage('Build and Test')`. The section has two parts, `steps` and `post`, which get run one after another.
1. `steps` will run the actual test code for our CI
2. `post` runs any clean up that's necessary after running the tests as well as running commands necessary to report the test results back to github


### Steps

Within the `steps` section, there's really only one command that's run
```
sh 'make build test-ci'
```
This is running two targets from a Makefile (an example `Makefile` [here](examples/Makefile)), `build` and `test-ci`. The Makefile is really just a thin wrapper around `make.sh` (shown [here](examples/make.sh)).

The `build` step builds a docker image to run the tests in. We build a docker image so that we have a reproducable test environment to run tests in without having to configure specific machines. This is a standard move you'll see in all our repos.

`test-ci` runs the actual tests in the repo.


### Post

The `post` section is doing three things
```
sh 'rm -f vault_pass.txt'
sh 'make clean'
junit 'test_results/*.xml'
```

The first two lines clean up the test infrastructure. The third line takes the test results and reports them back to Github so that Github knows whether our tests pass or fail.
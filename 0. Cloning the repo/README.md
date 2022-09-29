# Cloning a repo and setting up commit hooks
## Overview
This module goes over the very basics on cloning a repository. More specifically, we will be cloning our example/learning repo.

## Hands on activity
1. Go to the repo you want to clone: [here](https://github.com/dhirata-trumid/git-practice)
2. Click on the green `Code ▼` button
3. Copy the web url
4. In your terminal, navigate to the directory you want the cloned repo to be in and use `git clone` to clone it:
```shell
$ git clone https://github.com/dhirata-trumid/git-practice.git
```
5. If you don't have precommit follow the instructions [here](https://pre-commit.com/)
6. Once, installed run
```shell
$ pre-commit --version
$ pre-commit install
```
6. You're done!

# Getting Started
This repo is meant to be an example of using git for teammembers that might not be fluent or might just need to brush their skills up.

We will be running through the following scenarios:

1. Making a pull request
2. Dealing with merge conflicts
3. Moving changes to separate branches (and why we should use fresh branches)
4. TBD (precommit hooks, )

# Prework
Please do the following:

- make sure git is installed: `git --version`
- in terminal, powershell, etc go to the directory you would like to do this practice in
- clone the repo: `git clone https://github.com/dhirata-trumid/git-practice.git`
- navigate into the directory: `cd git-practice`

# Scenario 1: Making a pull request
1. Make a new branch off of master
    - make sure we're on `main` branch: `git branch`
    - if not on `main` then run `git checkout main`
    - create a new branch (-b creates a new branch with whatever name you want): `git checkout -b <your name>/make-a-pr`
2. Open the directory in your favorite IDE or text editor
3. Make a small change to `sample/core.py` and save it
4. Commit your changes:
    - `git status`
    - `git add sample/core.py`
    - `git commit -m "Patch: make a small change"`
5. Push your changes to a remote branch:
    - `git push origin <your branch name>`
    - if you forgot your branch name: `git branch`
6. Open the pr:
    - In your web browser to go [the repo](https://github.com/dhirata-trumid/git-practice)
    - Go to the pull requests tab towards the top (or click on the make new pull request tab if it's there)
    - Click create pull request and change the "compare" drop down to your branch
    - Create the pull request
7. Edit the pull request description
8. If you need to add changes to the pull request, just make changes to your local branch then push them to the remote branch (similar to step 4)

# Basics of committing: understanding the git index
## Overview
### The git index
In this section, we will be talking about a few key concepts that relate to how git handles files. The three important places where git handles files: working directory, staging area, and the repository.

When you add code/make changes in your local machine's filesystem, you are dealing with your project’s working directory. All the changes you make are considered only existing in the working directory until you add them to the staging area (via `git add` command). The staging area is best described as a preview of your next commit. Meaning, when you run a git commit, git will take the changes that are in the staging area and make the new commit out of those changes. One benefit of the staging area is that it allows you to fine-tune your commits. You can add and remove changes from staging area to your heart's content, after which, you can commit them. And after you commit your changes, git will update its index to keep track of the files that were updated.

The git index is a file that git uses to keep track of the file changes over the three areas: working directory, staging area, and repository. It's the central bookkeeper that keeps track of what commits and changes happen between the three git environments.

### Committing
At a high level, git commits can be seen as snapshots taken at a specific point in time. This is in contrast to other version management tools, such as SVN, that record each and every change to files in the repository. This has some advantages in workflow as you can make changes to your local repositories and choose when to add the changes back to the main/master branch without stepping on another teammember's toes.

The git commit command has a handful of options to commit your staged changes; however for simplicity's sake, we will be focusing on one and that's the `git commit -m` command. This command lets you commit your staged changes and include a message describing said changes.

## Hands on activity
1. In your cloned repo, run `git log`, you should see that the head pointer is at the most recent commit and you should be able to see where your remote branch is pointed to as well (origin/main)
2. Create a separate branch for a feature:
```shell
$ git checkout -b <your name>/part-1-feature
```
3. In terminal navigate to the 1. Basics of committing directory:
```shell
$ cd 1.\ Basics\ of\ committing/
```
4. Create a new file (however you want but below is for terminal):
```shell
$ touch some_pig.py
```
5. Check `git status` to see your unstaged changes.
6. Add the file to staging:
```shell
$ git add some_pig.py
```
7. In staging you can check `git status` again to see your change in staging.
8. Commit your change (make a good message!):
```shell
$ git commit -m "tried to save wilbur"
```
9. Check the commit log and you should see head has moved to be your new commit while remote branch should still point at the previous commit

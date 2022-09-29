# Building a new feature and making a pr
## Overview
When building a new feature it's worthwhile to always start on a fresh branch off of the main/master branch especially if the branch you're currently working on has had a pr created off of it. The reason is two-fold:

- At Trumid, when we commit to master via pr, we strongly prefer to `squash and merge`. The `squash and merge` function coalesces all of the commits on the pr into a single, new commit and merges that into master. So if you continue working on a branch which has had a pr merged off of it, the git histories will not align: your local branch will have all the commits before the squash and merge while the master branch will only have a single commit. This may create issues and "ghost changes" in your next pr.
- It's good to get in the habit of making sure you have the most up to date changes in your main/master branch. Creating feature branches off of updated master branches will make your life a ton easier as you'll have less merge conflicts and git issues in general.

## Hands on activity
1. Go to the root directory
2. Checkout main branch
3. Create a separate branch for a feature:
```shell
$ git checkout main
$ git pull origin main
$ git checkout -b <your name>/part-2-feature
```
4. In terminal navigate to the 1. Basics of committing directory:
```shell
$ cd 2.\ Building\ a\ new\ feature/
```
5. Create a new file (however you want but below is for terminal). Add some stuff to the file and let the precommit hooks run (easy one would be to 'forget' a new line at the eof):
```shell
$ touch bacon.py
```
6. Add the file to staging:
```shell
$ git add bacon.py
```
7. Commit it
```shell
$ git commit -m "not helping wilbur"
```
8. Push it to a remote branch:
```shell
$ git push origin <your branch name here>
```
9. Go to github and make a pr (don't forget to fill out the template when applicable)

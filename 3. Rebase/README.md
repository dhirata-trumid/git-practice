# Rebase

In this lesson you'll learrn
* What a git rebase is
* how to rebase
    * normal
    * interactive
* How to resolve conflicts when the arise

## What's a rebase?

At Trumid we practice trunk based developement. This means we want to drop new commits on top of master without needing to any sort of merge commit. Rebasing is a method for making sure we can do this by "catching up" your feature / development branch with any changes that have landed in master since you started development. Rebasing (instead of creating merge commits) offers a few benefits, including:
1. Producing clean diffs to master / main when you submit a PR on github
2. The ability to resolve conflicts (and test those resolutions) before merging your branch with master

If you were to visualized what's happening in a rebase, here's what it would look like. Before your rebrace, you may be a branch that looks like
```
          A---B---C branch
         /
D---E---F---G master
```
After rebasing branch onto master, it looks like:
```
              A'--B'--C' branch
             /
D---E---F---G master
```

## How can I rebase?

### Typical rebase experience

The most typical rebase experience consists of running these 4 commands
```
git checkout main          # checkout that main (or master) branch
git pull                   # pull down the latest changes on main from the remote github repo
git checkout <your_branch> # go back to your feature branch
git rebase                 # run a rebase
```


### Resolving conflicts


### Interactive rebase




## Further Reading
[Git Rebase Docs](https://git-scm.com/docs/git-rebase)
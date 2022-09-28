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

Try a typical rebase yourself!

1. make sure you have the latest version of main / master `git checkout main && git checkout master`
2. checkout a sample branch we've created for you `git checkout rebase_practice`
3. Take a look at what the git log looks like before you rebase
![before](images/git-log-after-simple-rebase.png)
4. Now, rebase your branch onto the lates version of main: `git rebase main`. Your should see output that looks like this
![output](images/git-rebase-simple-output.png)
5. Finally, take a look at what the git log of your branch looks like now. You'll see all your latest development commits coming after the latest commit to main.
![after](images/git-log-after-simple-rebase.png)

### Resolving conflicts

Occassionaly, a change you've made in your branch will conflict with a change that already exists in master. When this happens git-rebase will alert you to the conflicts and you'll have the opportunity to manually resolve them. In this section, we'll walk you through that process.



### Interactive rebase

Interactive rebase gives you a whole new power to rewrite your commit history and 


## Further Reading

* [Git Rebase Docs](https://git-scm.com/docs/git-rebase)
* [Squashing Commits](https://www.git-tower.com/learn/git/faq/git-squash)
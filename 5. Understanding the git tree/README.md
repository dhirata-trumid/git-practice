# Understanding the git tree
In this section we will lightly get into what git is doing under the hood and define some important terms.

As discussed earlier, git operates by keeping track of point in time snapshots of files and marks them with hashes. These underlying structures allow multiple contributors to develop features and eventually commit them to master branch. Recall in our rebase explanation:
```
          A---B---C branch
         /
D---E---F---G master
```
Each of the letters is a separate snapshot of the state of the files. Each commit is identified by its hash which can be used to traverse between commits and is used to show changes in files. The tree is basically a directory listing that is composed of sub-trees and file changes.

So if we add a commit H to the branch, our tree will look like this:
```
          A---B---C---H branch
         /
D---E---F---G master
```

## The HEAD pointer
Within git commands you may often see references to the term `HEAD`. The HEAD pointer is a special git ref that points to the commit of a branch you are currently working on. There will be a HEAD reference for each branch. When checking out a branch, the HEAD will default to the latest commit on that branch.

You can move the HEAD by checking out specific commits in your working directory (also known as a detached state). This should only be done under certain circumstances where you want to use a previous commit as a starting point for a new feature.

## Tags vs branches
Tags and branches are two ways that we can use to keep track of features within git. Both are references that allow you to view the repository at a specific point in time and will have their HEAD pointer point to a single commit. Branches are generally used to host feature changes, bug fixes, etc with the intention of eventually merging it back into the master branch. Tags on the otherhand are static pointers to specific commits; we use tags to indicate release candidates (often denoted as ondeck versions).

## Git pull
When pulling from another branch you are telling git to fetch and download changes from a remote repository and immediately update the local repository to match that content.
```
Remote A---B---C---D master

Local  A---B---C master

$ git pull origin master

Remote A---B---C---D master

Local  A---B---C---D master
```
You should use the pull command to keep your branches up to date with changes in the master branch.

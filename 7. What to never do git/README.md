# :bangbang: :x: What to never do in git :x: :bangbang:
## git push -f origin master/main
Pushing with the `-f` flag indicates that you are doing a force push, which sounds about as cool as it can be destructive. Force pushing forces the changes/commits on your local branch to the remote branch. There are some cases where you might want this behavior but you never want to perform this action on master. Generally, main/master branches should be protected from people pushing directly but just in case they aren't, try not to run force pushes against those branches.

## git reset --hard
Resets are an important tool to have and utilize; however, hard resets can be a bit dangerous as it modifies your working directory. Generally you want to undo your commits, but not completely undo the changes you've made. **Hard resets will drop any changes associated **

## stackoverflow answers
Stackoverflow is a great way to find answers to issues you might run into with git. Be very careful to not copy and paste commands without knowing exactly what each component of the answer does. If you don't understand what each part of the git commands an answer is recommending does, it might be worthwhile to consult someone else before trying out the command.

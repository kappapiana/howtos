---
title: how to duplicate just a branch of git for client
author: Carlo "Kappa" Piana
---

# Purpose

Developing stuff for many clients, but sharing only the branch and stuff that interests client. Being able to retrofit with new things, back and forth with client's edits.

# Howto

## Duplicate the repository

Create a new repository on Github

Create a new local repository and make it downstream to the original repo and fetch the objects.

```
git init
echo "something" > test
git add . && git commit -m "first commit" # creates master branch
git remote add origin [newrepo]
git remote add upstream [original_repo]
git fetch upstream
```


Now checkout the client's branch of the remote (clientspecific in this example):

```
git branch -r #lists the remote branches
git checkout -t upstream/clientspecific]
```

You have a local copy of the client's own branch. Now you need to have it as your master, but without the history.

## Merge upstream with local master

Now you have a copy of the remote branch and an empty local master, which does not track anything upstream (you can check with `git branch -vv`).

The idea is to merge without importing the history

```
git checkout master #go back to master
git merge --squash clientspecific --allow-unrelated-histories #master is synced with clientspecific, no history.
git branch --set-upstream-to=origin/master master
git push # (or perhaps git push -u origin/master master)
```

The same happens the other way round after changes to the new repo occur:

```
git checkout clientspecific
git merge --allow-unrelated-histories #first time only
[resolve merge conflicts]
git push # pushes master and clientspecific
```

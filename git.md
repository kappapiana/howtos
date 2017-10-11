---
Title: Git and how to use it for text stuff (mainly)
Author: Carlo Piana
---
<<<<<<< HEAD

# After a fork has been created

We add an upstream from the original (forked) repo, so everything is in sync

    git remote -v

Checks the status of the repository remote sources. Here you should have only your own github.

    git remote add upstream https://github.com/[whatever]

Adds the forked repository as a source

    git fetch upstream

Syncs the current version with the most updated upstream

    git checkout master

Uses the master branch

    git merge upstream/master

Reconciles the changes from the upstream with the local modifications.

    git status

Checks the current status

    git pull

Sends all changes from upstream to the github repository
=======
>>>>>>> 3a044df9e5809f21a75b080bf5c7625d360dfcf1

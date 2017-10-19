
---
Title: Git and how to use it for text stuff (mainly)
Author: Carlo Piana
subject: questo e quello
---

# Add upstream to existing directory

    git init
    git remote add origin https://github.com/kappapiana/cson.git
    git pull origin master


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

# Store credentials

Command line Git client will not remember your credentials out of the box. Make sure you are running Git version 1.7.12.1 or higher, then use the following command to enable password caching:

    git config --global credential.helper cache

This will make git remember your credentials for 15 minutes after you entered them. To increase that limit use the following command and specify time in seconds:

    git config --global credential.helper 'cache --timeout=3600'

## To store for a particular repository

Set a Git username:

    git config user.name "Mona Lisa"

Confirm that you have set the Git username correctly:

    git config user.name

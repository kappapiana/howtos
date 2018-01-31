
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


You need to setup the git credential helper with Gnome Keyring:

Install and compile the Gnome Keyring devel:

sudo apt-get install libgnome-keyring-dev
sudo make --directory=/usr/share/doc/git/contrib/credential/gnome-keyring

And setup the credential:

git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring


## To store for a particular repository

Set a Git username:

    git config user.name "Mona Lisa"

Confirm that you have set the Git username correctly:

    git config user.name


# resolve conflicts

    git mergetools

# pull for all subdirectories

One can use a scrip or a foreach, but actually, it's quite easy to use `find` and `-exec` to each first-level subdirectory.

    find -maxdepth 1 -mindepth 1 -type d -exec git -C {} pull \;

Bingo!


# Consolidate many commits into one

Usecase: you have a messy history of many changes that you have committed, but want to have a cleaner history.

_Optional:_ create a new branch and operate on that one

- checkout the branch you want to clean up.
- return (soft) to the last good commit 

this way:

    git reset --soft HEAD~3
    git commit -m "New message for the combined commit"

or

    git reset --soft da9e7f34064fe885ac76adf9c543dc98652f5568 #last commit id
    git commit -m "New message for the combined commit"

- sync with the remote repository, forcing (using `+`). 

Like:
    
    git push origin +master

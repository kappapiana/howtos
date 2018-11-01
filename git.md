---
Title: Git and how to use it for text stuff (mainly)
Author: Carlo Piana
subject: questo e quello
---

# Add upstream to existing directory

If the project exists remotely but not Here

    git clone $projectname

If the project does not exist, create one online and push local stuff there

    git init
    git remote add origin https://github.com/kappapiana/$projectname
    git push origin master #sure it is this way?


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

    git push

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
<<<<<<< HEAD
 
_Optional:_ create a new branch and operate on that one
=======

## the correct way

**not optional** create a new branch and always operate on that one. Otherwise it's a mess.

    git fetch upstream

To align with the most recent upstream

    git rebase -i master --autostash

Aligns with the master, then you can commit all changes into a new commit.

Careful to select "fixup" to the comments you want to discard.

Done. Now you will want to amend the comment, to capture all the changes.

    git commit --amend


Now you can merge your branch back into the master, if you are happy with the changes.

## The harder way

Otherwise, you could do something harder.
>>>>>>> 6627186... Explain how to merge

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


## Prompt

    parse_git_branch() {
      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }

    export PS1="\[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

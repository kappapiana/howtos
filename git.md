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

but actually Atom has a resolver embedded (some package? can't tell). Quite efficient.

# pull for all subdirectories

One can use a scrip or a foreach, but actually, it's quite easy to use `find` and `-exec` to each first-level subdirectory.

    find -maxdepth 1 -mindepth 1 -type d -exec git -C {} pull --all \;

Bingo!

TODO implement this thing:

    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
    git pull --all

because if I have created branch on one computer, I might fail to have on a different computer.

# Consolidate many commits into one


Usecase: you have a messy history of many changes that you have committed, but want to have a cleaner history.

## The correct way

**not optional** always create a new branch and operate on that one. Otherwise it's a mess. So you have made a few changes in the branch and want to merge with the master, removing all the mess in the feature commits.

first off, fetch upstream, otherwise you will have conflicts with that.

    git fetch upstream

then checkout to the feature

    git checkout feature

Now we redo all the changes into one:

    git rebase -i master --autostash

This aligns with the master, allowing you to squash the intervening commits (with fixup)

Careful to select "fixup" to the comments you want to discard.

Done. Now you will want to amend the only remaining comment, to capture all the changes.

    git commit --amend


Now you can merge your branch back into the master, if you are happy with the changes.

## The hard way

Otherwise, you could do something harder.

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

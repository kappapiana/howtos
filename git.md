---
Title: Git and how to use it for text stuff (mainly)
Author: Carlo Piana
subject: questo e quello
---

# General stuff

## Store credentials

You need to setup the git credential helper with Gnome Keyring:

Install and compile the Gnome Keyring devel:

    sudo apt-get install libgnome-keyring-dev
    sudo make --directory=/usr/share/doc/git/contrib/credential/gnome-keyring

And setup the credential:

    git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring


## In general, to config

    git config --global user.name kappapiana

To store for a particular repository

Set a Git username:

    git config user.name "kappapiana"

Confirm that you have set the Git username correctly:

    git config user.name

## List of current global config

    credential.helper=/usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring
    user.name=kappapiana
    user.email=carlo@piana.eu
    core.editor=vim
    diff.tool=tkdiff
    merge.tool=meld

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

    $ git checkout master

Ensure you are on master

    $ git pull upstream master && git push origin master

gets stuff from upstream and ensures the github respository is aligned

## Work on your stuff

    $ git checkout -b hotfix/readme-update

Creates a **new branch**. `Always do this!!!`

To push the new branch and be aligned also with that:

    $ git push -u origin hotfix/readme-update

Now the upstream branch is aligned with the local. All pushes are local too.

On a new work on the project:

    git branch -r

Checks all branches on the remote.

    git branch

Checks all local branches. Compare the two.

Alternatively (not advisable):

    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
    git pull --all

because if I have created branch on one computer, I might fail to have on a
different computer. This checks all local and remote are aligned



# resolve conflicts

    git mergetools

but actually Atom has a resolver embedded (some package? can't tell). Quite efficient.

# Few tricks

## Pull for all subdirectories

One can use a scrip or a foreach, but actually, it's quite easy to use `find` and `-exec` to each first-level subdirectory.

    find -maxdepth 1 -mindepth 1 -type d -exec git -C {} pull --all \;

Bingo!

## Consolidate many commits into one


Usecase: you have a messy history of many changes that you have committed, but want to have a cleaner history.

## The correct way

You can avoid messing up by using one single commit and amend it

    git add #stages some modified file

    git commit --amend  #commits all staged file into the previous commit
                        #(and allows to change the message)


So you have made a few changes in the branch and want to merge with the master, removing all the mess in the feature commits.

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

Otherwise, you could do something harder (absolutely not advisable).

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

on `~/.bashrc`

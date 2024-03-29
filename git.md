---
Title: Git and how to use it for text stuff (mainly)
Author: Carlo Piana
subject: questo e quello
---

# General stuff

## Store credentials

You need to setup the git credential helper with Libsecret:

```shell
sudo apt install libsecret-1-0 libsecret-1-dev
cd /usr/share/doc/git/contrib/credential/libsecret
sudo make
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
```

## In general, to config

    git config --global user.name kappapianaù

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

Ensure you are on master

    $ git checkout master

Now add the upstream

    $ git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY

and make sure you are aligned

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

## Get a remote branch to local

    git branch -r #gets the List

    git checkout -t origin/[namebranch] #copies remote branch, sets to track it



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


## Prompt

on `~/.bashrc`, add the following lines:

```bash
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="${debian_chroot:+($debian_chroot)}\[\033[32m\]\u@\h \[\033[36m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]: \n$ "

```

## Remove gone branches

use the `git gone` alias

`$ git config --global --edit`

and add this to the `[alias]` section:
```

    gone = ! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == \"[gone]\" {print $1}' | xargs -r git branch -D
`

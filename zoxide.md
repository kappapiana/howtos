---
title: how to jump to recent directories with zoxide
author: Carlo "Kappa" Piana
---

# Purpose

Get back to directories visited recently or often from the terminal, without typing full paths or guessing. zoxide remembers where you have been and ranks directories by frequency and recency ("frecency").

Built-in alternatives, for when zoxide is not installed:

- `cd -` toggles back to the previous directory
- `pushd dir` / `dirs -v` / `cd ~2` keep and use a numbered stack of directories
- in zsh, `setopt AUTO_PUSHD PUSHD_IGNORE_DUPS` records every `cd`; then `cd -<TAB>` shows the list
- `Ctrl+R` and type part of a path to find an old `cd` in history

# Howto

## Install

```bash
sudo apt install zoxide fzf   # Debian/Ubuntu
sudo pacman -S zoxide fzf     # Arch
```

fzf is optional but needed for the interactive picker (`zi`).

## Hook it into the shell (one time)

Add at the end of the shell config (check the shell with `echo $SHELL`):

```bash
# bash → ~/.bashrc
eval "$(zoxide init bash)"

# zsh → ~/.zshrc
eval "$(zoxide init zsh)"

# fish → ~/.config/fish/config.fish
zoxide init fish | source
```

Reload with `source ~/.bashrc` (or `~/.zshrc`), or open a new terminal.

To replace `cd` itself instead of using `z`, init with `--cmd cd`:

```bash
eval "$(zoxide init bash --cmd cd)"   # then `cd proj` jumps, `cdi` is the picker
```

## Let it learn

zoxide only knows directories visited after the hook is active. Keep using `cd` normally (or `z` with full paths) for a while.

## Jump around

```bash
z proj          # best match for "proj" (most frequent + recent)
z work api      # several words: path containing "work", then "api"
z -             # previous directory
z ..            # works like cd too
zi              # interactive picker (fzf): type to filter, Enter to go
zi proj         # picker pre-filtered with "proj"
```

Matching favours the last part of the path: `z api` prefers `~/work/api` over `~/api-stuff/other`. If it picks the wrong one, use `zi`.

## Manage the database

```bash
zoxide query -l          # list known directories, ranked
zoxide query -ls         # same, with scores
zoxide add /some/path    # teach a directory without visiting it
zoxide remove /old/path  # forget a directory
```

## Bonus: fzf shell keys

With fzf's shell integration enabled:

- `Alt+C` fuzzy-find a directory under the current one and cd into it
- `Ctrl+R` fuzzy search the command history

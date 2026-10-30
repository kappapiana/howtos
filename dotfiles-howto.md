# Dotfiles howto

Dotfiles live in a **bare git repo** at `~/.dotfiles.git`, with `$HOME` as the work tree.
Remote: `git@gitlab.justice4all.it:kappapiana/dotfiles.git`

The command is `dotfiles` (an alias defined in `~/.bashrc`). It is **not** `git`.
Plain `git` in `$HOME` does nothing useful on purpose.

Short aliases (in `~/.bash_aliases`):

| Alias   | Does                           |
|---------|--------------------------------|
| `ds`    | `dotfiles status`              |
| `da`    | `dotfiles add`                 |
| `dc`    | `dotfiles commit`              |
| `dff`   | fetch + status                 |
| `dpush` | push                           |
| `dpull` | pull, then re-source `.bashrc` |

---

## 1. ONE-TIME FIX on every machine that already exists

Why: a bare clone does not set the fetch refspec, so `dotfiles fetch` never
created `origin/master` and `ds` never showed ahead/behind.

Already done on the first machine (2026-10-30). On **each other machine**:

```shell
dotfiles config --local remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dotfiles fetch
ds
```

Expected: `ds` now prints `## master...origin/master` (plus any changes).
Check it took:

```shell
dotfiles config --get-all remote.origin.fetch
```

Expected output: `+refs/heads/*:refs/remotes/origin/*`

If `dotfiles` says "command not found", run `source ~/.bashrc` first.

---

## 2. Daily use

See what changed / what is out of sync:

```shell
dff
```

Save a change you made to a config file:

```shell
da ~/.config/foo/bar.conf     # ONE file at a time
dc -m "short description"
dpush
```

Get changes made on another machine:

```shell
dpull
```

### Rules

- Add files **one by one**. NEVER `da .`, `da ~` or `da ~/.config`.
  The work tree is your whole home folder: you would sweep in caches, secrets
  and machine-specific files.
- Do not sync per-machine files (`~/.gitconfig.local`, `~/.claude/settings.json`,
  `~/.config/gomuks/config.yaml`, etc.). See `~/README_dotfiles.md` for the list.

---

## 3. Pull stops with an error

### "untracked working tree files would be overwritten"

A file was added to the repo that already exists locally.

```shell
mv ~/path/to/file ~/path/to/file.mine
dpull
diff ~/path/to/file ~/path/to/file.mine    # decide which one to keep
```

### A file was made per-machine (untracked) in the repo

`dpull` **deletes it from disk** on the other machines. Back it up first:

```shell
cp -p ~/path/to/file ~/path/to/file.keep
dpull
mv -f ~/path/to/file.keep ~/path/to/file
```

### Merge conflict

```shell
ds                       # lists conflicted files
# edit them, remove the <<<<<<< ======= >>>>>>> markers
da ~/path/to/file        # for each conflicted file
dc                       # finishes the merge
dpush
```

---

## 4. Setting up a NEW machine

Copy-paste in order. The fetch line is the fix from section 1.

```shell
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
git clone --bare git@gitlab.justice4all.it:kappapiana/dotfiles.git $HOME/.dotfiles.git
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dotfiles fetch
dotfiles checkout
```

If `checkout` fails with "would be overwritten by checkout", move the listed
files aside and retry:

```shell
mv ~/.bashrc ~/.bashrc_backup      # repeat for every file listed
dotfiles checkout
```

Then:

```shell
source ~/.bashrc
printf '[user]\n\tname = YOUR NAME\n\temail = YOUR@EMAIL\n' > ~/.gitconfig.local
ds
```

Expected: `ds` shows `## master...origin/master` and nothing else.

---

## 5. Creating the repo from scratch (reference only)

```shell
git init --bare $HOME/.dotfiles.git
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dotfiles add ~/.bashrc
dotfiles commit -m 'Initial commit with .bashrc'
dotfiles remote add origin git@gitlab.justice4all.it:kappapiana/dotfiles.git
dotfiles push -u origin master
```

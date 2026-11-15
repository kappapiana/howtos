# Restore and rebuild after a reinstall

How to get data and an equivalent system back from the backup drive
(`/media/carlo/unenc_backup`) onto a fresh install (Pop!_OS or Ubuntu).

## 0. Before wiping the old system

```bash
~/script/backup/foto_copper-toshiba.sh -s
```

- Saves package lists, GNOME settings and dotfiles to `~/backup-state`.
- `-s` also saves `~/.ssh`, `~/.gnupg` and `~/.local/share/keyrings` to
  `~/backup-state/secrets.tar.gpg`, encrypted with a passphrase. **Write that
  passphrase down somewhere other than this computer.** The drive is not
  encrypted, so the secrets never go there in plain form.
- Then copies everything in `backup.list.txt` (including `~/backup-state`) to
  the drive.
- Check `~/backup-state/TIMESTAMP` on the drive to confirm it's today's run.

Not covered by the backup. Copy these by hand if you need them:

- `~/.config`, `~/.mozilla` and `~/.thunderbird`. Firefox and Thunderbird are
  easier to restore by signing in to Firefox Sync, or by copying the profile
  folder. They contain saved passwords, so don't leave them on the plain drive.
- `~/Documents`, `~/Downloads`, `~/Desktop` and anything else not in
  `backup.list.txt`.
- Changes under `/etc` other than the apt sources and the hibernate setup.

## 1. Restore the data

Mount the drive. Then do a dry run (`-n`) before copying for real:

```bash
B=/media/carlo/unenc_backup
for d in Pictures Videos darktable_gallery vm git popos-migration \
         backups_euroit .claude Music backup-state; do
    rsync -avn "$B/$d/" "$HOME/$d/"    # remove -n when the output looks right
done
```

The trailing `/` on both sides copies the *contents* into the folder of the same
name. Files are written as your new user, so ownership is correct as long as you
run this as your user and without `sudo`.

## 2. Secrets

```bash
gpg -d ~/backup-state/secrets.tar.gpg | tar -C "$HOME" -xf -
chmod 700 ~/.ssh ~/.gnupg
chmod 600 ~/.ssh/id_*  ;  chmod 644 ~/.ssh/*.pub
```

The keyring contains the login passwords for WiFi, browsers and so on. It
unlocks with the **old** login password, so either use the same password on the
new install or change it in *Passwords and Keys* (seahorse) afterwards.

## 3. Packages

**No snap, ever.** Do this first, so that nothing can pull `snapd` back in:

```bash
sudo apt purge -y snapd 2>/dev/null; rm -rf ~/snap
sudo tee /etc/apt/preferences.d/no-snap.pref >/dev/null <<'EOF'
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
```

With this pin, apt refuses any package that needs snapd. On Ubuntu that
includes the `firefox` and `thunderbird` debs, which are only wrappers around
the snap. Pop!_OS ships real debs for both, so there they install normally. On
Ubuntu, use Mozilla's apt repo (packages.mozilla.org) or flatpak instead.

```bash
S=~/backup-state

# apt: third-party repos first, then packages
sudo cp -n $S/apt/keyrings/* /etc/apt/keyrings/ 2>/dev/null
sudo cp -n $S/apt/sources.list.d/* /etc/apt/sources.list.d/
sudo apt update
xargs -a $S/apt/apt-manual.txt sudo apt install -y --ignore-missing
```

If apt stops on a package that doesn't exist on the new release, remove that
line from the list and run the command again. Packages that only existed on
Ubuntu (or only on Pop!_OS) are the usual cause.

```bash
# flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
xargs -a $S/flatpak.txt flatpak install -y flathub

# apps that used to be snaps on the old system
sudo apt install -y docker.io hugo micro cups
flatpak install -y flathub org.chromium.Chromium org.telegram.desktop

# pip user packages
pip install --user -r $S/pip-user.txt

# node: install nvm first, then the version and globals listed in npm-global.txt
```

## 4. Settings and dotfiles

```bash
cp -i ~/backup-state/dotfiles/.[!.]* ~/       # -i asks before overwriting
dconf load / < ~/backup-state/dconf.ini       # GNOME settings, shortcuts, extensions
crontab ~/backup-state/crontab.txt            # only if it's not empty
```

`dconf load` overwrites the new desktop's settings. On Pop!_OS (COSMIC or a
different GNOME version) restore only the parts you want, for example
`dconf dump /org/gnome/desktop/wm/keybindings/` from the old file. Loading
everything can break the new desktop.

## 5. System tweaks

```bash
ln -s git/stuff/howtos/script ~/script     # scripts, including this backup
cd ~/popos-migration && sudo bash setup-hibernate.sh
```

`setup-hibernate.sh` assumes Pop!_OS with full-disk encryption. Read its header
first, and never add `mem_sleep_default=deep` (it hangs on this BIOS).

## 6. Check

- `ssh -T git@github.com` and `gpg -K` work.
- `cd ~/git/<repo> && git status` (repos came back with their history).
- Run `~/script/backup/foto_copper-toshiba.sh -d` once, to confirm the backup
  works on the new system.

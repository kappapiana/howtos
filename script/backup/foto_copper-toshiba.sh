#!/bin/bash
# Back up the folders in backup.list.txt to the external drive.
#   -d   dry run (no state dump, rsync --dry-run)
# See RESTORE.md for how to bring everything back on a new install.

DEST=/media/carlo/unenc_backup
STATE="$HOME/backup-state"
LIST="$(dirname "$0")/backup.list.txt"

RSYNC_OPTS=(-av)
DRY=0
for arg in "$@"; do
    case "$arg" in
        -d) DRY=1; RSYNC_OPTS+=(--dry-run) ;;
        *) echo "usage: $0 [-d]" >&2; exit 2 ;;
    esac
done

if ! mountpoint -q "$DEST"; then
    echo "$DEST is not mounted, aborting." >&2
    exit 1
fi

# Save what is needed to rebuild the system (packages, settings, dotfiles).
dump_state() {
    mkdir -p "$STATE/dotfiles" "$STATE/apt"
    # No snap, ever: leave out snapd and Ubuntu's snap-wrapper packages.
    apt-mark showmanual | grep -vxE 'snapd|chromium-browser|gnome-software-plugin-snap' \
        > "$STATE/apt/apt-manual.txt"
    cp -r /etc/apt/sources.list.d "$STATE/apt/" 2>/dev/null
    [[ -d /etc/apt/keyrings ]] && cp -r /etc/apt/keyrings "$STATE/apt/" 2>/dev/null
    command -v flatpak >/dev/null && flatpak list --app --columns=application > "$STATE/flatpak.txt"
    command -v pip >/dev/null && pip list --user --format=freeze > "$STATE/pip-user.txt" 2>/dev/null
    command -v npm >/dev/null && npm ls -g --depth=0 > "$STATE/npm-global.txt" 2>/dev/null
    command -v dconf >/dev/null && dconf dump / > "$STATE/dconf.ini"
    crontab -l > "$STATE/crontab.txt" 2>/dev/null
    for f in .bashrc .profile .bash_aliases .gitconfig .vimrc; do
        [[ -f "$HOME/$f" ]] && cp "$HOME/$f" "$STATE/dotfiles/"
    done
    date -Iseconds > "$STATE/TIMESTAMP"
    echo "System state saved to $STATE"
}

if (( DRY == 0 )); then
    dump_state
    # Keys and saved passwords, copied as they are (no extra password).
    tar -C "$HOME" -cf "$STATE/secrets.tar" .ssh .gnupg .local/share/keyrings \
        && chmod 600 "$STATE/secrets.tar" \
        && echo "Keys saved to $STATE/secrets.tar"
fi

while IFS= read -r dir || [[ -n "$dir" ]]; do
    [[ -z "$dir" ]] && continue
    rsync "${RSYNC_OPTS[@]}" "$dir" "$DEST/"
done < "$LIST"

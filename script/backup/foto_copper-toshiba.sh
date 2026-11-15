#!/bin/bash

RSYNC_OPTS=(-av)
if [[ "$1" == "-d" ]]; then
    RSYNC_OPTS+=(--dry-run)
fi

LIST="$(dirname "$0")/backup.list.txt"

while IFS= read -r dir || [[ -n "$dir" ]]; do
    [[ -z "$dir" ]] && continue
    rsync "${RSYNC_OPTS[@]}" "$dir" /media/carlo/unenc_backup/
done < "$LIST"

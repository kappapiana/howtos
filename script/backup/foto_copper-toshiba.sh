#!/bin/bash

DRY_RUN=""
if [[ "$1" == "-d" ]]; then
    DRY_RUN="--dry-run"
fi

while IFS= read -r dir || [[ -n "$dir" ]]; do
    [[ -z "$dir" ]] && continue
    rsync -av $DRY_RUN "$dir" /media/carlo/unenc_backup/
done < backup.list.txt

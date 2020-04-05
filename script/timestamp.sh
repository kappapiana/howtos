#!/usr/bin/env bash

date +"%Y-%m-%d %H:%M" | while read line; do echo -n "$line"; done | xclip -i -selection clipboard

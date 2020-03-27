#!/usr/bin/env bash

/bin/date +"%Y-%m-%d" | /usr/bin/tr -d '\n' | /usr/bin/xclip -i -selection clipboard

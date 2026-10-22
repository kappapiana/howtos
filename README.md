# howtos

Personal reference notes and small scripts. Content is a mix of English and Italian.

Quick search from the terminal: `grep -rniI "keyword" --include="*.md" .`

## Git

| File | What it covers |
|---|---|
| [git.md](git.md) | Credentials, config, forks and upstream, branches, squashing commits, shell prompt with branch, `git gone` alias |
| [git-duplicate.md](git-duplicate.md) | Share only one branch with a client, without history, and keep it in sync |

## Terminal and Linux

| File | What it covers |
|---|---|
| [zoxide.md](zoxide.md) | Jump to recent directories with `z` / `zi`; `cd -`, `pushd` and fzf alternatives |
| [comandi_utili.md](comandi_utili.md) | Misc commands, see sections below |
| [regexp.md](regexp.md) | Regex recipes for LibreOffice, Atom and grep (capture groups, non-greedy, IP addresses, GDPR article headings) |

Sections in `comandi_utili.md`:

- iptables: ban/unban an IP, whitelist, save rules, fail2ban blocklist
- Logs: extract offending IPs from `mail.log`
- Conservazione: verify S/MIME `.eml` files, hash lists, inspect `.p7m` with openssl, download the CA list
- Pandoc: quick styled HTML
- Ubuntu: silence event sounds
- GNOME: HiDPI fractional scaling (X11 and Wayland)
- `git diff` to coloured HTML with `aha`
- Tailscale install
- HDR: `align_image_stack` + `enfuse`
- Copy command output to the clipboard (`wl-copy` / `xclip`)

## Networking and servers

| File | What it covers |
|---|---|
| [route_nat.md](route_nat.md) | KVM/libvirt: static IP for a guest and port forwarding with iptables (saved copy of a blog post) |

## Documents and writing

| File | What it covers |
|---|---|
| [atom-mod.p.md](atom-mod.p.md) | Atom setup for writing articles (legacy): packages, Pandoc filters, spell check |
| [cson/snippets.cson](cson/snippets.cson) | Atom snippets for Markdown and pandoc-crossref |
| [tables-workaround.md](tables-workaround.md) | LibreOffice: tables too wide in docx/odt output |
| [revealjs.md](revealjs.md) | Serve slides with reveal.js |

## Desktop and devices

| File | What it covers |
|---|---|
| [extensions.md](extensions.md) | GNOME extensions in use |
| [remarkable.md](remarkable.md) | reMarkable: ssh access, adding custom templates, creating templates |
| [pulire-video.md](pulire-video.md) | Clean up the audio of a video with ffmpeg + Audacity |

## Misc

| File | What it covers |
|---|---|
| [moto_trackday.md](moto_trackday.md) | Trackday packing checklist (`.html` / `.pdf` are generated from it) |

## Scripts (`script/`)

| Script | What it does |
|---|---|
| [datestamp.sh](script/datestamp.sh) | Copies today's date (`YYYY-MM-DD`) to the clipboard |
| [timestamp.sh](script/timestamp.sh) | Copies date and time (`YYYY-MM-DD HH:MM`) to the clipboard |
| [hashline.sh](script/hashline.sh) | SHA-256 of each line of a text file (share a list without revealing it) |
| [darktable_clean.sh](script/darktable_clean.sh) | Stops the camera auto-mount, then starts darktable if not running |
| [documenti.sh](script/documenti.sh) | Opens `~/Documenti` (or `~/Documents`) in Nautilus |
| [pratiche.sh](script/pratiche.sh) | Opens `~/Documents/pratiche` in Nautilus |
| [backup/foto_copper-toshiba.sh](script/backup/foto_copper-toshiba.sh) | rsync `~/Pictures` to the external USB drive |

## Conventions

- One topic per file, short code blocks that can be copied as they are.
- New file: add a row to the right table above.

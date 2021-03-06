---
title: modifiche
---
# Creazione Ambiente per articoli

* disabilitato markdown-preview
* installato markdown-preview-enhanced (risolve scroll sync non funziona)
* installato language-pfm
* disabilitato language-gfm
* Project home in /home/carlo/Documents/markdown
* Warn on large file limit 2 (mb)
* Installato markdown-writer
* Installato Markdown-preview-enhanced
* Installato TODO-show
  - inserire directory escluse
  - controllare che ci siano (commentati in YAML)
    - ACTION  something you have to do;
    - NB, XXX something that needs to be filled in the agreement;
    - TBD an open point for discussion;
    - TODO something we have to do (=action for you);
    - FIXME something needing fixing (=nb for you) sostituiti
* Installato atom-increment (per aggiornare elenchi incrementali non automatici)
* Installato open-terminal-here
* Supporto lingua: ``` en-US, it-IT ``` in spell check
* Creata la keybind in markdown-writer (`Packages > Markdown Writer > Configurations > Create Default Keymaps`)
<!-- * Pandoc-crossref -->
* Aggiornato l'elenco snippet con il file snippets.cson nel repository git
* aggiunto pacchetto markdown-folding per poter collassare gli header
* aggiunto pacchetto magic-reflow, disabilitato autoflow
* creato shortcut

```
'atom-workspace atom-text-editor':
'alt-q': 'magic-reflow:reflow'
```

* aggiunto dizionario italiano che non sega le accentate:
    - <https://addons.mozilla.org/firefox/downloads/file/666908/dizionario_italiano-5.0.0-an+fx+sm+tb.xpi?src=dp-btn-primary
    - Unzip + locale path in Spell-checker package
* In bracket-matcher inserito espressamente i caratteri <> (default non funziona)!

# Replicare install

- Installare **sync-settings** https://atom.io/packages/sync-settings
- Seguire le istruzioni locali per il primo backup
- Clonare install in altri posti ("Cloning a backup to a fresh Atom install")

# Nuovi moduli (non standard)

Abbiamo creato o modificato o implementato moduli che non stanno nella distribuzione originale. Ci si fanno cose interessanti. Se ci si installa **markdown-preview-enhanced**, la si imposta per usare il parser Pandoc e usare include-pandoc invece di Pandoc, usando i moduli aggiuntivi, si ha una preview del documento complesso abbastanza fedele. in *Pandoc options: commandline arguments*, inserire:

    --filter=pandoc-mustache, --filter=crossref-ordered-list, --filter=pandoc-vex, --filter=pandoc-crossref, --filter=pandoc-inline-headers

## Pandoc-crossref

- O installare via cabal
- O installare direttamente il binario tirandolo giù da github
<https://github.com/lierdakil/pandoc-crossref/releases>

## include-pandoc

È un wrapper per Pandoc che consente l'inclusione di pezzi di markdown come se fossero "locali"

    sudo pip install include-pandoc && sudo include-pandoc --update

## inline git diff

Serve a verificare cosa è cambiato dall'ultimo commit proprio o dall'ultimo commit di qualcun altro.

    apm install alpianon/atom-inline-git-diff


## Inline headers

Crea un tipo di headers che non stanno su un paragrafo a se, ma che stanno sulla stessa riga del paragrafo (non intestazione) che segue.

Segui:
<https://github.com/alpianon/pandoc-inline-headers>

    sudo pip3 install pandoc-inline-headers

## Mustaches

Per inserire variabili in doppie curly brackets. Le variabili vanno scritte in un file YAML

    sudo pip3 install pandoc-mustache


## Inline-git-diff (mod)

```bash
cd ~/.atom/packages/inline-git-diff
git_sync_with_remote.sh
git_sync_with_remote.sh
git checkout dev-select-commit
apm install
```

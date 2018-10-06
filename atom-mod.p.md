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
* backup .atom
* aggiunto pacchetto markdown-folding per poter collassare gli header
* aggiunto pacchetto magic-reflow, disabilitato autoflow
* creato shortcut  ```
'atom-workspace atom-text-editor':
'alt-q': 'magic-reflow:reflow'
```

* aggiunto dizionario italiano che non sega le accentate:
    - <https://addons.mozilla.org/firefox/downloads/file/666908/dizionario_italiano-5.0.0-an+fx+sm+tb.xpi?src=dp-btn-primary
    - Unzip + locale path in Spell-checker package
* In bracket-matcher inserito espressamente i caratteri <> (default non funziona)

+++
title = "Blogeinträge mit Denote und Hugo"
author = ["Matthias Fuchs"]
description = "This text was generated using the After Dark post archetype."
date = 2024-04-25T09:22:00+02:00
lastmod = 2024-04-25T14:22:55+02:00
tags = ["hugo"]
categories = ["Denote"]
draft = false
+++

## Denote {#denote}

Hier erkläre ich meinen Workflow in `org-mode` und `denote` für meine persönlichen Blog "After Dark".

-   `C-c n t` (`denote-template`) "post"-Template
-   Titel eingeben
-   automatisches filetags: hugo
-   Keywords: hugo
-   Hugo-Categories: nur **eine** Kategorie eintragen
-   Blogtext schreiben
-   save file
-   export to hugo: `C-c C-e H H` (export to HUGO markdown file)
-   `C-c C-e H o` (export to Hugo Markdown and open)


## Git / magit {#git-magit}


### Workflow in Git {#workflow-in-git}

```bash
$ hugo server -D			## Kontrolle; startet lokalen Server
$ Crtl-C 				## lokalen Server beenden
$ hugo                              ## Website in /public erstellen
$ git add .				## git-Befehle, auch im /public directory eingeben
$ git commit -m "einen commit schreiben"
$ git push -u origin main
```


### `magit` Befehle {#magit-befehle}

Voher in `eshell` die `Hugo` Befehle eingeben.

-   `M-x magit`
-   `s s` (stage)
-   `c c` (commit) end with: `C-c C-c`
-   `m m` (merge)
-   `P p` (push)

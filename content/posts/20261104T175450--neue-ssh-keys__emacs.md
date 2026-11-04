+++
title = "Neue ssh keys"
author = ["Matthias Fuchs"]
description = "That was tricky."
date = 2026-11-04T17:54:00+01:00
lastmod = 2026-11-04T21:19:34+01:00
tags = ["emacs"]
categories = ["Emacs"]
draft = false
[cover]
  image = "images/gentle.jpg"
  alt = "Beschreibung des Bildes"
+++

## Auf einmal Panik {#auf-einmal-panik}

Nachdem ich es geschafft habe, dass `hugo` die Anführungszeichen korrekt darstellt, gab es Probleme mit den `ssh-keys`.


## Dann Ruhe {#dann-ruhe}

Nach einigen erfolglosen Versuchen habe ich neue `ssh-keys` erstellt und das deploy-Skript umgeschrieben. Nun sind der Blog und das zweite Repo für meine `org`-Dateien sauber getrennt. Aus Sicherheitsgründen zeige ich das Skript nicht hier. Im Prinzip läuft es so, dass es direkt auf einen eigenen `ssh key` zugreift (unabhängig von der ssh `config`-Datei).

`magit` kann dann ungestört auf diese `config`-Datei zugreifen und den dort konfigurierten `ssh-key` für das `org`-Repo.

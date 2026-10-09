+++
title = "git und ssh"
author = ["Matthias Fuchs"]
description = "Der goldene Standard"
date = 2026-10-09T19:25:00+02:00
lastmod = 2026-10-09T20:13:48+02:00
tags = ["emacs", "git"]
draft = false
+++

## Es war "mühsam" {#es-war-mühsam}

Bis musste ich bei jeder Aktion auf `git` den Benutzernamen und den Token eingeben. Das war mehr als mühsam. Zusätzlich musste ich den Token alle 90 Tage neu generieren und ändern. Weshalb ich heute nach einer anderen Möglichkeit gesucht habe, diesen Prozess auf eine elegantere Weise durchzuführen.


## Der `ssh-key` {#der-ssh-key}

In den nächsten Zeilen zeige ich, wie man ein Git Repo auf ssh umstellt. Zuerst erstellt man einen privaten ssh-key auf seinem Gerät. Dazu führt man im Terminal foldgenden Befehl durch:

```bash
ssh-keygen -t ed25519 -C "deine-email@example.com"
```

Bestätige die Abfragen einfach mit Enter (ein Passwort für den Schlüssel ist optional, erhöht aber die Sicherheit).

```bash
cat ~/.ssh/id_ed25519.pub
```

Die Ausgabe im Terminal kopieren.

Gehe auf GitHub zu den **Settings** → **SSH and GPG keys** → **New SSH key**. Gib dem Schlüssel einen Namen (z. B. "Mein Laptop") und füge den kopierten Text aus dem Terminal vom vorhergehenden Schritt bei **Key** ein.

Da dein Blog-Repository aktuell noch über HTTPS läuft, musst du Git sagen, dass es ab jetzt SSH nutzen soll. Wechsel in deinem Terminal in den Ordner deines Blogs und gib Folgendes ein:

Im Hauptverzeichnis (wo z.B. die Markdown Dateien liegen):

```bash
git remote set-url origin git@github.com:afterdarkblog/afterdarkblog.github.io.git
git push origin main --force
```

Dann - im public-Verzeichnis:

```bash
cd public
git remote set-url origin git@github.com:afterdarkblog/source.git
git push origin main --force
cd ..
```

In Zukunft sollte git nicht mehr nach `username` und `password` bzw `token` fragen.

Da ich meinen Blog [After Dark](https://afterdarkblog.github.io/) in den letzten Tagen auf ein neues Theme umgestellt hatte, nahm ich dies zum Anlass, weitere Umstellungen und Verbesserungen vorzunehmen. Ich habe dem Blog ein Favicon verpasst, das sich automatisch je nach hellem oder dunklem Theme des Geräts in der Farbe anpasst:

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="100%" height="100%">
  <defs>
    <style>
      .triangle {
        fill: none;
        stroke: #FF3366; /* Gelb-Orange im Light Mode */
        stroke-width: 4;
        stroke-linejoin: round;
      }
      @media (prefers-color-scheme: dark) {
        .triangle {
          stroke: #00E5FF; /* Leuchtendes Cyan-Blau im Dark Mode */
        }
      }
    </style>
  </defs>
  <polygon points="16,4 28,27 4,27" class="triangle"/>
</svg>
```

Der Blog lädt blitzschnell, sieht schick aus und es macht mir viel Freude, immer wieder einen neuen Beitrag zu verfassen. Das Schreiben hilft mir, meine Gedanken zu formulieren und zu verbessern. Im Schreiben kann ich tiefer über ein Thema nachdenken - es gilt, im Flow zu bleiben. Einfach zu schreiben. Die Gedanken werden kommen und sich weiter entwicklen. Das ist spannend. Noch eine kleine Verbesserung zum Schluss.

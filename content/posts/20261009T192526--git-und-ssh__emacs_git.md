+++
title = "git und ssh"
author = ["Matthias Fuchs"]
description = "Der goldene Standard"
date = 2026-10-09T19:25:00+02:00
lastmod = 2026-10-10T14:45:58+02:00
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
git remote set-url origin git@github.com:REPONAME/REPONAME.github.io.git
git push origin main --force
```

Dann - im public-Verzeichnis:

```bash
cd public
git remote set-url origin git@github.com:REPONAME/source.git
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

Der Blog lädt blitzschnell, sieht schick aus und es macht mir viel Freude, immer wieder einen neuen Beitrag zu verfassen. Das Schreiben hilft mir, meine Gedanken zu formulieren und zu verbessern. Im Schreiben kann ich tiefer über ein Thema nachdenken - es gilt, im Flow zu bleiben. Einfach zu schreiben. Die Gedanken werden kommen und sich weiter entwicklen.


## Fehlerbehebungen {#fehlerbehebungen}

Im Zuge der Umstellung von Token auf ssh-key kam es zu einigen Fehlermeldungen. Ich habe das fehleranfällige Git-Submodul komplett eliminiert. Vorher war mein public-Ordner ein „Submodul“ – also ein eigenständiges Git-Repository, das tief in der versteckten Datenbank des Hauptordners verankert war. Da der Pagefind-Suchindex bei jedem Durchlauf alle Dateien in diesem Ordner neu generiert, gerieten die unsichtbaren Verbindungsketten (die Commit-Zeiger) ständig asynchron. Das hat die ständigen Fehler in den GitHub Actions ausgelöst. Ich habe mein System auf eine saubere Trennung und absolute Unabhängigkeit umgestellt. Hier ist die genaue Übersicht, was sich geändert hat:

```bash
git rm --cached public
rm .gitmodules

git add -A .
git commit -m "Entferne fehlerhaftes Git-Submodul endgültig"
git push origin main --force

# Das führte noch nicht zum gewünschten Erfolg ...

# 1. Das Submodul radikal aus dem versteckten Git-Verzeichnis löschen
rm -rf .git/modules/public

# 2. Den alten Konfigurationseintrag direkt aus der Git-Config entfernen
git config --remove-section submodule.public 2>/dev/null

# 3. Den aktuellen Stand der echten Dateien einscannen und committen
git add -A .
git commit -m "Cleanup: Versteckte Submodul-Reste endgültig entfernt"

# 4. Den bereinigten Stand mit Gewalt auf GitHub hochladen, um dortige Reste zu überschreiben
git push origin main --force

# Es kam zu einer Fehlermeldung ...
# Im Hauptverzeichnis
git rebase --abort

# Im Public-Verzeichnis
cd public
git remote set-url origin git@github.com:REPONAME/REPONAME.github.io.git
git add -A .
git commit -m "Live-HTML Update"
git push origin main --force
cd ..

# Hauptverzeichnis:
git remote set-url origin git@github.com:REPONAME/source.git
git add -A .
git commit -m "Quellcode Backup Update"
git push origin main --force

# Im Public Verzeichnis gab es eine Fehlermeldung ...
git rebase --abort

git reset --hard HEAD
git remote set-url origin git@github.com:REPONAME/REPONAME.github.io.git
git add -A .
git commit -m "Live-HTML Update nach Bereinigung"
git push origin main --force

# Hauptverzeichnis
cd ..
git remote set-url origin git@github.com:REPONAME/source.git
git add -A .
git commit -m "Quellcode Backup Update"
git push origin main --force
```


### Das Submodul ist weg {#das-submodul-ist-weg}

Der public-Ordner ist für mein Hauptverzeichnis jetzt ein ganz normaler, lokaler Ordner ohne Sonderstatus. Damit das Hauptverzeichnis nicht versucht, HTML-Dateien mitzusichern, steht der Ordner nun auf einer lokalen Ignorier-Liste (.git/info/exclude). Es gibt keine versteckten Zeiger mehr, die online kaputtgehen können.


### Die Repositories wurden getauscht (Der entscheidende Fix) {#die-repositories-wurden-getauscht--der-entscheidende-fix}

Ich habe die Datenströme in meinem Skript so umgeleitet, dass sie exakt zu meiner Struktur auf GitHub passen:

Die fertige Website (public)
: Lädt die reinen HTML/CSS-Dateien jetzt direkt in mein Live-Repository REPONAME.github.io hoch. GitHub Pages nimmt diese Dateien und schaltet meinen neuen Post sofort live.


Der Quellcode (Hauptordner)
: Lädt meine Markdown-Dateien und Hugo-Einstellungen als sicheres Backup in das Repository source hoch.


### Von Token auf SSH gewechselt {#von-token-auf-ssh-gewechselt}

Ich authentifiziere mich nicht mehr über HTTPS mit einem Passfahrtschein (Token), der alle 90 Tage abläuft. Mein Computer nutzt jetzt einen festen SSH-Schlüssel. Git wandelt jede GitHub-Adresse im Hintergrund automatisch um, gleicht meinen Schlüssel ab und lässt mich ohne jegliche Passworteingabe gewähren.


### Das Ergebnis für dich: {#das-ergebnis-für-dich}

Mein Skript steuert die beiden Repositories nun nacheinander als zwei völlig getrennte Welten an. Es lädt erst die Webseite auf die Bühne (Live-Repo) und sichert danach das Skript und die Texte im Safe (Backup-Repo). Es kann sich technisch nichts mehr blockieren.


## Brille gebrochen {#brille-gebrochen}

Vor ein paar Tagen brach mir die Fassung meiner Brille. Ich hab sie mit Superkleber repariert. Dabei wurde das Glas zerkratzt. Und heute ist sie mir ein zweites Mal gebrochen. Mit Leopold sind wir beide in die Stadt gefahren. Leider bin ich zuerst zur Stadtbibliothek gefahren, um Bücher zurück zu bringen und neue auszuborgen. Warum leider? Ich dachte - den Optiker mache ich am Rückweg. Denn ich hatte ein Geschäft in Nonntal während der Hinfahrt entdeckt. Der Optiker in Nonntal schließt um 12h30. Es war knapp, aber wir haben es doch geschafft und nun habe ich wieder eine ordentliche Brille.

{{< figure src="/images/Gebrochene_Brille.jpg" alt="wunderschön" title="Gebrochene Brille" class="border-2" width="100%" height="100%" >}}

{{< figure src="/images/Neue_Brille.jpg" alt="wunderschön" title="Neue Brille" class="border-2" width="100%" height="100%" >}}

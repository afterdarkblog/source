#!/bin/bash

# Sicherheit: Sicherstellen, dass das Skript im Hauptverzeichnis ausgeführt wird
if [ ! -d "public" ]; then
    echo "Fehler: Bitte führen Sie dieses Skript aus dem Hauptverzeichnis des Projekts aus!"
    exit 1
fi

# 1. HTML-Seiten lokal generieren
echo "Generiere HTML mit Hugo..."
hugo --minify

# 2. Suchindex von Pagefind erstellen lassen
echo "Erstelle Suchindex mit Pagefind..."
npx pagefind --site public

# Kurze Pause für das Dateisystem
sleep 1

# 3. Commit-Nachricht abfragen
echo -n "Bitte Commit-Nachricht eingeben: "
read commit_message

if [ -z "$commit_message" ]; then
    commit_message="Blog aktualisiert am $(date +'%Y-%m-%d')"
fi

# ==============================================================================
# HIER SIND DIE GEÄNDERTEN ZEILEN (SCHLÜSSEL-ERZWINGUNG FÜR DEN BLOG-ACCOUNT)
# ==============================================================================

# 4. IM PUBLIC-VERZEICHNIS: Die fertige Website ins Live-Repository hochladen
echo "Pushe fertige Website in das Live-Repository..."
cd public

# Ersetzen Sie die alte git config Zeile durch diese Zeile:
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_github_blog -o IdentitiesOnly=yes -F /dev/null"

# Erzwingt, dass die fertigen HTML-Dateien an das Live-Repository gehen
git remote set-url origin git@github.com:afterdarkblog/afterdarkblog.github.io.git

git add -A .
git commit -m "$commit_message"
git pull origin main --rebase
git push origin main
cd ..

# Kurze Pause, damit GitHub im Hintergrund die HTML-Daten verarbeiten kann
echo "Warte kurz auf GitHub Sync..."
sleep 3

# 5. IM HAUPTVERZEICHNIS: Den Quellcode als Backup in das source-Repository sichern
echo "Sichere Quellcode im source-Repository..."

# Ersetzen Sie auch hier die alte git config Zeile durch diese Zeile:
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_github_blog -o IdentitiesOnly=yes -F /dev/null"

# Erzwingt, dass deine Markdown-Quelltexte im Backup-Repository landen
git remote set-url origin git@github.com:afterdarkblog/source.git

# Sorgt dafür, dass das Hauptverzeichnis den public-Ordner ignoriert (kein Submodul-Müll!)
if [ ! -f .git/info/exclude ] || ! grep -q "^public/" .git/info/exclude; then
    echo "public/" >> .git/info/exclude
fi

git add -A .
git commit -m "$commit_message"
git pull origin main --rebase
git push origin main

echo "--------------------------------------------------------"
echo "Fertig! Webseite ist live und Quellcode sicher im Backup!"
echo "--------------------------------------------------------"

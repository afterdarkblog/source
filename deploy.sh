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

# 4. IM PUBLIC-VERZEICHNIS: Die fertige Website hochladen
echo "Pushe fertige Website..."
cd public
git add -A .
git commit -m "$commit_message"
git pull origin main --rebase
git push origin main
cd ..

# Kurze Pause, damit GitHub im Hintergrund die Daten verarbeiten kann
echo "Warte kurz auf GitHub Sync..."
sleep 3

# 5. IM HAUPTVERZEICHNIS: Nur den Quellcode (ohne den public-Inhalt) sichern
echo "Sichere Quellcode im Hauptverzeichnis..."
# Wir fügen public zur Sicherheit lokal zur Ignorier-Liste hinzu, damit kein Zeiger-Müll hochgeladen wird
if [ ! -f .git/info/exclude ] || ! grep -q "^public/" .git/info/exclude; then
    echo "public/" >> .git/info/exclude
fi

git add -A .
git commit -m "$commit_message"
git pull origin main --rebase
git push origin main

echo "Fertig! Ihr Blog inklusive Suche ist im Submodul-Modus live und Ihr Terminal bleibt grün!"

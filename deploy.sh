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

# 4. IM SUBMODUL (public): Die fertige Website zu GitHub Pages pushen
echo "Pushe fertige Website aus dem public-Ordner..."
cd public
git add -A .
git commit -m "$commit_message"
git push origin main
cd ..

# 5. IM HAUPTVERZEICHNIS: Den neuen Submodul-Zeiger und Quellcode sichern
echo "Sichere Quellcode im Hauptverzeichnis..."
# --ignore-submodules=none zwingt Git, das public-Submodul trotz eventueller Config-Einträge sauber mitzunehmen
git add --ignore-submodules=none public
git add -A .
git commit -m "$commit_message"
git push origin main

echo "Fertig! Ihr Blog inklusive Suche ist im Submodul-Modus live und Ihr Terminal bleibt grün!"

#!/bin/bash

# 1. HTML-Seiten lokal generieren
echo "Generiere HTML mit Hugo..."
hugo --minify

# 2. Suchindex von Pagefind erstellen lassen
echo "Erstelle Suchindex mit Pagefind..."
npx pagefind --site public

# 3. Commit-Nachricht abfragen
echo -n "Bitte Commit-Nachricht eingeben: "
read commit_message

if [ -z "$commit_message" ]; then
    commit_message="Blog aktualisiert am $(date +'%Y-%m-%d')"
fi

# 4. IM SUBMODUL (public): Die fertige Website zu GitHub Pages pushen
echo "Pushe fertige Website aus dem public-Ordner..."
cd public
git add .
git commit -m "$commit_message"
git push origin main  # Falls Ihr public-Branch anders heißt, z.B. gh-pages, hier anpassen
cd ..

# 5. IM HAUPTVERZEICHNIS: Den neuen Submodul-Zeiger und Quellcode sichern
echo "Sichere Quellcode im Hauptverzeichnis..."
git add .
git commit -m "$commit_message"
git push origin main

echo "Fertig! Ihr Blog inklusive Suche ist im Submodul-Modus live."

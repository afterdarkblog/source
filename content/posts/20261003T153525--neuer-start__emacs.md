+++
title = "Neuer Start"
author = ["Matthias Fuchs"]
description = "Neue Sprachen und eine neue Schule"
date = 2026-10-03T15:35:00+02:00
lastmod = 2026-10-03T16:57:29+02:00
tags = ["emacs"]
categories = ["emacs"]
draft = false
+++

## Neues Theme 'PaperModX' {#neues-theme-papermodx}

Meinen Blog habe ich vom Theme "Archie" auf das Theme "PaperModX" umgestellt. Mir war nicht bewusst, dass diese Änderung so viel Arbeit mit sich bringen würde. Dafür war viel Geduld und Ausdauer notwendig; viel Frustration, kleine Erfolge, dann wieder ein Rückschlag. Als dann endlich ein Aspekt wie die Suchfunktion einwandfrei lief - war der zuvor eingerichtete Copyright Text verschwunden oder wollte sich dann nicht so auf der ersten Seite einrichten lassen, wie ich es mir vorstellte.

Als dann der Blog einigermaßen meinen Vorstellungen entsprach, spielte git ziemlich verrückt. Wieder Geduld, Ausdauer, Rückschläge, kaum Fortschritte, ... und dann - endlich: ein kleiner Erfolg - und schließlich: alles läuft wieder korrekt.

Nebeneffekt: ich lerne neue Sprachen wie html und css kennen.


## Code Highlight {#code-highlight}

Folgenden Code habe ich in meine `hugo.toml` eingebaut:

```toml
[markup]
  [markup.highlight]
    codeFences = true        # Aktiviert Highlighting für Blöcke mit ```
    lineNos = false          # Schaltet globale Zeilennummern ein (true) oder aus (false)
    noClasses = false        # WICHTIG für PaperModX: CSS-Klassen statt Inline-Styles nutzen
    style = "monokai"        # Das Chroma-Fallback-Design (wird oft durch Theme-CSS überschrieben)
```

Damit man den Codeblock kopieren kann:

```toml
[params]
  # Zeigt einen "Kopieren"-Button an allen Code-Blöcken an
  ShowCodeCopyButtons = true

  # Erlaubt das horizontale Scrollen bei sehr langen Codezeilen
  # anstelle eines automatischen Zeilenumbruchs
  # lineNumbersInTable = true # Setze dies auf true, falls lineNos=true genutzt wird, für besseres Layout
```

Weiters habe ich eine `custom-code.css` in `/assets/css/extended` ertellt. `PaperModX` bringt bereits perfekt optimierte Styles für Code-Blöcke mit, die sich automatisch an den Hell- oder Dunkelmodus deines Blogs anpassen. Beispiel für eine andere Hintergrundfarbe im Dark-Mode:

```css
/* ==========================================
   CODE-BLOCK STYLING (Chroma / PaperModX)
   ========================================== */
.post-content pre {
    background-color: #1e1e24 !important; /* Dunklerer Hintergrund */
    border-radius: 8px;
    border: 1px solid #333;
}

/* Inline-Code-Schnipsel im Textfluss */
.post-content code {
    background-color: #f5f5f5;
    color: #e06c75;
    padding: 2px 6px;
    border-radius: 4px;
}

/* Anpassung für den Dark-Mode */
.dark .post-content code {
    background-color: #2c2c32;
    color: #61afef;
}
```


## Neues Schuljahr - "neue" Schule {#neues-schuljahr-neue-schule}

Seit diesem Schuljahr bin ich nun für eine volle Lehrverpflichtung an der MS Mattsee, eine Schule mit einem sehr guten Ruf, netten Kollegen und freundlichen Kindern. Ich hoffe, dass ich endlich ankommen kann. Meine Ruhe und meinen Frieden finde.

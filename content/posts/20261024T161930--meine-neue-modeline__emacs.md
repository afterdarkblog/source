+++
title = "Meine neue Modeline"
author = ["Matthias Fuchs"]
description = "Simple is beautiful."
date = 2026-10-24T16:19:00+02:00
lastmod = 2026-10-24T22:40:38+02:00
tags = ["emacs"]
categories = ["Emacs"]
draft = false
[cover]
  image = "images/purple-gnu.jpg"
  alt = "Beschreibung des Bildes"
+++

## Meine alte `mode-line` {#meine-alte-mode-line}

Vorher habe ich Prot's Version seiner `mode-line` verwendet. Sie hat super funktioniert; dafür habe ich allerdings drei riesige Dateien gebraucht. Warum?

Dass meine Modeline jetzt so kurz ist und trotzdem genau das tut, was ich will, liegt daran, dass ich sie maßgeschneidert auf meine Bedürfnisse geschrieben habe. Prots Code hingegen ist deshalb so extrem lang, weil er einem völlig anderen Design-Philosophie-Ansatz folgt.
Hier sind die Hauptgründe, warum Prots Modeline-Code Hunderte von Zeilen umfasst:


### Universelle Kompatibilität (Er baut für alle, nicht nur für sich) {#universelle-kompatibilität--er-baut-für-alle-nicht-nur-für-sich}

Prot veröffentlicht seine Konfigurationen für die gesamte Emacs-Community. Sein Code muss auf jedem Betriebssystem (Linux, macOS, Windows) und mit jeder Emacs-Version (auch älteren Versionen vor Emacs 29) fehlerfrei laufen.

Wo ich einfach voraussetze, dass ich modernste Emacs-Funktionen wie `mode-line-window-selected-p` oder `mode-line-format-right-align` nutze, baut Prot oft komplexe, abwärtskompatible Fallback-Funktionen per Hand nach.


### Extremes Edge-Case-Handling {#extremes-edge-case-handling}

Was passiert, wenn ein Buffer keine Datei ist (z. B. **Messages** oder Dired)? Was, wenn Git im Hintergrund abstürzt? Was, wenn der Buffer schreibgeschützt ist?

Prot fängt jeden erdenklichen Sonderfall mit eigenen `if`- und `cond`-Abfragen ab. Das macht den Code extrem robust, bläht ihn aber massiv auf. Der kurze Code vertraut darauf, dass Emacs die Standardfehler im Hintergrund leise selbst regelt.


### Verzicht auf externe Pakete (Die "Vanilla"-Philosophie) {#verzicht-auf-externe-pakete--die-vanilla-philosophie}

Prot vermeidet externe Pakete (wie nerd-icons oder all-the-icons), wo es nur geht.

Um die Symbole und Trenner anzuzeigen, die du in deinen ersten Screenshots hattest (¶, ƒ, ⎸), berechnet er die exakten Abstände, Text-Eigenschaften (Faces) und Schriftgewichte im Code selbst. Das Erzeugen dieser textbasierten Grafiken direkt in reinem Elisp benötigt extrem viel Code-Infrastruktur.


### Das modus-themes Ökosystem {#das-modus-themes-ökosystem}

Prots Modeline ist tief in seine bekannten Themes integriert. Sie lauscht dynamisch darauf, welches Theme ich gerade aktiviere, und passt die Farben der Modeline, des Git-Status und der Schriftarten im Hintergrund live an. Diese tiefe Verwebung erfordert viele Hilfsfunktionen (Helper Functions) und Variablen, die ich in meiner privaten, festen Konfiguration schlicht nicht brauche.


### Fazit {#fazit}

Prots Code ist wie ein Schweizer Taschenmesser: schwer, vollgepackt und für jede Situation gerüstet. Meine neue Modeline ist wie ein Skalpell: superscharf, federleicht und exakt für meine Hand geschmiedet.


## Die Konfiguration meiner `mode-line` {#die-konfiguration-meiner-mode-line}

```emacs-lisp
;;; my modeline
;; Ich habe den sehr langen Code von Prot durch meine eigene, schlanke
;; 'mode-line' ersetzt. Prot's Code ist deshalb so lange, weil er nicht
;; für sich schreibt, sondern für alle Emacs-User und für alle erdenklichen
;; Szenarien. Was passiert, wenn ein Buffer keine Datei ist (z. B. *Messages* oder Dired)?
;; Was, wenn Git im Hintergrund abstürzt?
;; Was, wenn der Buffer schreibgeschützt ist?
;; Für die Icons berechnet er die exakten Abstände,
;; Text-Eigenschaften (Faces) und Schriftgewichte im Code selbst.
;; Das Erzeugen dieser textbasierten Grafiken direkt in reinem Elisp
;; benötigt extrem viel Code-Infrastruktur.
;;
;; Meine Modeline erzielt das gleiche Ergebnis mit wesentlich weniger Code,
;; weil sie auf meine Bedürfnisse maßgeschneidert ist.

;; =============================================================================
;; 1. HILFSFUNKTIONEN FÜR DIE ICONS
;; =============================================================================

(defun my-modeline-vc-info ()
  "Zeigt ein echtes Nerd-Icon und den reinen Branch-Namen ohne Emacs-Raute."
  (when vc-mode
    (let* ((backend (vc-backend buffer-file-name))
           ;; Schneidet das native Emacs-Icon und das Backend (z.B. "Git:") ab
           (branch (string-trim (substring vc-mode (+ 2 (length (symbol-name backend))))))
           (active-face (if (mode-line-window-selected-p) 'warning 'shadow))
           ;; Filigranes, scharfes Git-Branch Icon aus den Octicons
           (git-icon (nerd-icons-octicon "nf-oct-git_branch" :face active-face :height 0.95 :v-adjust -0.05)))
      (concat git-icon " " branch))))

(defun my-modeline-major-mode ()
  "Zeigt das passende Major-Mode-Icon in seiner echten Originalfarbe."
  (let ((icon (if (mode-line-window-selected-p)
                  ;; AKTIV: Absolut vanilla nerd-icons (bringt die Farben automatisch mit)
                  (nerd-icons-icon-for-mode major-mode :height 0.95 :v-adjust -0.05)
                ;; INAKTIV: Erzwingt das ausgegraute Aussehen
                (nerd-icons-icon-for-mode major-mode :face 'mode-line-inactive :height 0.95 :v-adjust -0.05))))
    (concat (if icon (concat icon " ") "") (format-mode-line mode-name))))

(setq modus-themes-grafts nil)


;; =============================================================================
;; 2. DAS NATIVE MODELINE FORMAT (AKTIV / INAKTIV STEUERUNG)
;; =============================================================================

(setq-default mode-line-format
  '("%e"
    " "
    ;; Diese Elemente sind IMMER sichtbar (Sowohl in aktiven als auch inaktiven Fenstern)
    mode-line-mule-info
    mode-line-modified
    " "
    "%b"                                  ; Buffer- / Dateiname
    "   "
    (:propertize "%l : %c" :face 'shadow) ; Zeile : Spalte (ausgegraut)

    ;; DYNAMISCHER MITTELTEIL: Wird NUR im aktiven Fenster angezeigt
    (:eval
     (when (mode-line-window-selected-p)
       (let ((vc-str (my-modeline-vc-info)))
         (append
          (when vc-str (list " " vc-str))   ; Git-Icon + Branch
          (list "   "
                (propertize "| " 'face 'shadow) ; Unser sauberer Trenner
                (my-modeline-major-mode))))))  ; Major-Mode Icon + Name

    ;; RECHTSBÜNDIGKEIT: Drückt alles Folgende an den rechten Bildschirmrand
    mode-line-format-right-align
    " "

    ;; ERC KANÄLE: Direkt platziert (damit ERC sie aktiv aktualisiert),
    ;; aber visuell nur im aktiven Fenster sichtbar geschaltet.
    (:eval (when (and (mode-line-window-selected-p)
                      (boundp 'erc-modified-channels-object))
             erc-modified-channels-object))

    ;; RECHTLICHES MISC-INFO: (Für mu4e, Uhrzeit, etc.)
    ;; Wird ebenfalls sauber nur im aktiven Fenster gerendert.
    (:eval (when (mode-line-window-selected-p)
             ;; Wir filtern ERC hier heraus, da wir es oben bereits separat zeichnen
             (let ((misc (copy-sequence mode-line-misc-info)))
               (assq-delete-all 'erc-modified-channels-object misc)
               misc)))))

;; Modeline-Cache global auffrischen
(force-mode-line-update t)


;; display time in the default mode-line
(setq display-time-24hr-format t)
(display-time-mode t)
(setq display-time-string-forms
'((propertize (format-time-string " %a %d %b, %R " now))))

(setq-default header-line-format
              '("%f"))
```


## Beispiel Bilder {#beispiel-bilder}

Ich habe es geschafft, Bilder ab jetzt "clickable" zu machen; das bedeutet, man kann mit der Maus draufklicken und sie werden in voller Größe dargestellt, in einem Popup. Für `org-mode` ändert sich dadurch Folgendes:

```org
#+ATTR_HTML: :class border-2 :alt wunderschön :title Blick auf Donau - Donaucity
[[/images/Donau1.jpg]]
```

So binde ich in Zukunft Bilder in die `org`-Datei ein. Wenn ich ein Bild sowohl in der Breite als auch in der Höhe auf 100% zwinge, riskieren ich, dass das Bild im Browser verzerrt (gestaucht oder in die Länge gezogen) wird, falls das Seitenverhältnis des Bildes nicht exakt mit dem des Bildschirms übereinstimmt.

-   Breite (:width 100%): Ist super! Das sorgt dafür, dass das Bild auf Smartphones und großen Monitoren immer die volle Breite des Textbereichs ausnutzt.
-   Höhe (:height 100%): Sollte der Browser automatisch berechnen, um das Seitenverhältnis des Fotos perfekt zu schützen.

Damit ich in Org-mode in Zukunft sogar das :width 100% bei fast jedem Bild weglassen kann (was mir viel Tipparbeit spart), kann ich eine einzige Zeile in mein globale CSS-Datei (z. B. eine `custom.css` oder die soeben erstellte `glightbox.min.css`) einfügen:

```css
figure img {
    width: 100%;
    height: auto; /* Berechnet die Höhe immer automatisch und verhindert Verzerrungen */
    display: block;
}
```

{{< figure src="/images/modeline1.png" alt="wunderschön" title="Blick auf Donau - Donaucity" class="border-2" >}}

{{< figure src="/images/modeline2.png" alt="wunderschön" title="Blick auf Donau - Donaucity" class="border-2" >}}

{{< figure src="/images/modeline3.png" alt="wunderschön" title="Blick auf Donau - Donaucity" class="border-2" >}}

{{< figure src="/images/modeline4.png" alt="wunderschön" title="Blick auf Donau - Donaucity" class="border-2" >}}


## Weitere Bilder {#weitere-bilder}

Diesmal habe ich die Einstellungen für die Größe von Fotos am Handy verändert.

{{< figure src="/images/Blume1.jpg" alt="wunderschön" title="Blick auf Donau - Donaucity" class="border-2" >}}

{{< figure src="/images/Blume2.jpg" alt="wunderschön" title="Blick auf Donau - Donaucity" class="border-2" >}}

{{< figure src="/images/Blume3.jpg" alt="wunderschön" title="Blick auf Donau - Donaucity" class="border-2" >}}

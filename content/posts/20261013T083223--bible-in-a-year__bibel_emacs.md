+++
title = "Bible in a Year"
author = ["Matthias Fuchs"]
description = "Gottes Wort"
date = 2026-10-13T08:32:00+02:00
lastmod = 2026-10-17T00:16:27+02:00
tags = ["bibel", "emacs"]
categories = ["bible"]
draft = false
[cover]
  image = "images/gold-fern-like-tree.jpg"
  alt = "Beschreibung des Bildes"
+++

## Psalm 119,41 u. 43.44–45.47–48 {#psalm-119-41-u-dot-43-dot-44-45-dot-47-48}

> Es komme zu mir, Herr, deine Liebe, ∗<br />
> nach deinem Spruch die Rettung durch dich.<br />
> Entziehe niemals meinem Mund das Wort der Treue, ∗<br />
> denn auf deine Entscheide warte ich!<br />
> Ich will deine Weisung beständig beachten, ∗<br />
> auf immer und ewig.<br />
> Ich schreite hinaus ins Weite, ∗<br />
> denn deine Befehle suche ich.<br />
> Ich ergötze mich an deinen Geboten, ∗<br />
> [ ] die ich liebe.


## Bible in a Year {#bible-in-a-year}

Bin im Moment bei Tag 286, mitten in der Epoche der Revolte der Makkabäer. Heute habe ich gelesen:

-   1 Makkaabäer 5
-   Jesus Sirach 13-15
-   Sprichwörter 22,13-16

Es ist großartig. Jeden Tag auf Gottes Wort hören, gerade durch diesen speziellen Leseplan, ist eine große spirituelle Freude. Dieser Plan unterteilt die Heilsgeschichte in zwölf Abschnitte, wodruch der innere Zusammenhang von Gottes Wirken erkennbar wird. Der Podcast von Fr. Mike Schmitz ist einzigartig. Seit Weihnachten 2025 höre ich täglich zu und lese mit.


## Links zu anderen Posts und Headline {#links-zu-anderen-posts-und-headline}

Dafür verwende ich den typischen org-link `[[file:mein-anderer-post.org][anderen Beitrag]]`.

Im Org-Mode
: Der Link funktioniert direkt in Emacs.

Beim Export (.md)
: `ox-hugo` konvertiert dies automatisch in einen relativen Markdown-Link (z. B. `[anderen Beitrag](../mein-anderer-post/)`).

In HTML
: Hugo rendert daraus den fertigen HTML-Link.

Um einen Link zu einer Headline in einem Post herzustellen, muss ich zuerst im verlinkten Post unter der gewünschten Headline ein `org-set-property` (`C-c C-x p`) setzen.

```org
* Eine wichtige Unterüberschrift
 :PROPERTIES:
 :CUSTOM_ID: mein-anker-punkt
 :END:
 Text unter der Überschrift...
```

Der Link dorthin sieht folgendermaßen aus: `[[file:mein-anderer-post.org::#mein-anker-punkt][spezifischen Abschnitt]]`. Wichtig ist dabei der doppelte Doppelpunkt `::#`. Im nächsten Satz hab ich zum vorherigen Post, und dort zum Abschnitt meiner kaputten Brille verlinkt. Hier mache ich noch einen Link zu [Brille gebrochen]({{< relref "20261009T192526--git-und-ssh__emacs_git#Brille" >}}). Damit möchte ich nur wissen, ob diese Art von Link auch online funtkioniert.

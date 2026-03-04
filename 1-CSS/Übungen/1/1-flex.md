# **Teil 1 – Grundstruktur des Menüs (10 Minuten)**

## **Aufgabe**

Erstelle ein HTML-Dokument mit einem Navigationsmenü:

* Verwende `<nav>` + `<ul>` + `<li>` + `<a>`.
* Füge 5 Menüeinträge hinzu: Home, Features, Pricing, Support, About.
* Gib dem `ul` die Klasse `site-nav`.


**Warum ist ein `<ul>` die sinnvollste Struktur für ein Navigationsmenü?**
Ein Navigationsmenü ist eine **Liste von Links**, daher ist eine ungeordnete Liste (`<ul>`) die **semantisch passende Struktur**, unterstützt Screenreader und ist standardkonform.
---

# **Teil 2 – Flexbox aktivieren (10 Minuten)**

## **Aufgabe**

Style das Menü so, dass die Menüeinträge **nebeneinander** stehen:

* Entferne Standardliste (`list-style: none`)
* Entferne Padding
* Aktiviere Flexbox: `display: flex`
* Füge Hintergrundfarbe hinzu


**Warum setzen wir `display: flex` auf das `<ul>` und nicht auf das `<nav>`?**
Weil **das `<ul>` die direkten Kinder `<li>` enthält**, die zu Flex-Items werden sollen.
`<nav>` enthält meist nur ein einziges `<ul>` → Flexbox hätte dort keinen Effekt.
```html
<nav>
  <ul class="site-nav">
    <li><a href="/">Home</a></li>
    <li><a href="/features">Features</a></li>
    <li><a href="/pricing">Pricing</a></li>
    <li><a href="/support">Support</a></li>
    <li class="nav-right"><a href="/about">About</a></li>
  </ul>
</nav>
```
---


# **Teil 3 – Menüeinträge stylen (5 Minuten)**

## **Aufgabe**

* Setze alle `<a>` auf `display: block;`
* Nutze Padding für schöne Klickflächen
* Entferne Unterstreichungen


**Warum bekommt das `<a>` das Padding und nicht das `<li>`?**
Weil **nur das `<a>` klickbar ist**.
Wenn das Padding auf `<li>` wäre, wäre die sichtbare Fläche größer als der klickbare Bereich → schlechte Usability.

---

# **Teil 4 – Abstand zwischen Menüitems (10 Minuten)**

## **Aufgabe**

Erzeuge Abstand **nur zwischen** den Menü-Items:

* Verwende den Selektor `.site-nav > li + li`
* Setze `margin-left: 1.5em`

**Warum nutzen wir den adjacent sibling combinator (`+`)?**
Der `+` Selektor erzeugt **Abstand nur zwischen Geschwistern**, nicht vor dem ersten Element.
So bleibt das Layout sauber und kontrolliert.
---

# **Teil 5 – Ein Item nach rechts schieben mit `margin-left: auto` (10 Minuten)**

## **Aufgabe**

* Verschiebe nur das letzte Menüelement (`About`) ganz nach rechts
* Nutze dafür:
  `.site-nav > .nav-right { margin-left: auto; }`


**Warum funktioniert `margin-left: auto` als „Platzfüller“ bei Flexbox?**

In Flexbox kann `auto`-Margin **freien Raum absorbieren**.
Das Element mit `margin-left: auto` nimmt den gesamten verfügbaren Platz ein → es rutscht ganz nach rechts.

# **Kompletter Lösungs-Code (HTML + CSS)**

## **HTML**

```html
<nav>
  <ul class="site-nav">
    <li><a href="/">Home</a></li>
    <li><a href="/features">Features</a></li>
    <li><a href="/pricing">Pricing</a></li>
    <li><a href="/support">Support</a></li>
    <li class="nav-right"><a href="/about">About</a></li>
  </ul>
</nav>
```

## **CSS**

```css
.site-nav {
  display: flex;
  padding: .5em;
  list-style: none;
  background-color: #5f4b44;
  border-radius: .2em;
}

.site-nav > li {
  margin-top: 0;
}

.site-nav > li > a {
  display: block;
  padding: .5em 1em;
  background-color: #cc6b5a;
  color: white;
  text-decoration: none;
}

.site-nav > li + li {
  margin-left: 1.5em;
}

.site-nav > .nav-right {
  margin-left: auto;
}
```

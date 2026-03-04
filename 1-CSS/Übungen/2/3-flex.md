# **Flexbox-Übung – Flex Container & Flex Items**

# **Teil 1 – Flex Container Basis**

## **Aufgabe 1 — Flex Container aktivieren**

Erstelle diese HTML-Struktur und aktiviere Flexbox:

```html
<div class="box">
  <div>A</div>
  <div>B</div>
  <div>C</div>
</div>
```

Setze im CSS:

* flex aktivieren
* Hintergrundfarbe für `.box`

---

### **Frage 1**

Was macht `display: flex` mit der `<div class="box">`?

---


# **Teil 2 – Flex Direction **

## **Aufgabe 2 — Richtung ändern**

Erzeuge 2 Layoutvarianten:

1. `.row` → Items nebeneinander
2. `.col` → Items untereinander

---

# **Teil 3 – Justify Content**

## **Aufgabe 3 — Items auf der Hauptachse verteilen**

Mache ein Menü, das so verteilt ist:

```html
<nav class="menu">
  <a>Home</a>
  <a>Pricing</a>
  <a>About</a>
</nav>
```

Setze:

* `justify-content: space-between`
* Hintergrundfarbe
* gleiches Padding

---

### **Frage 3**

Welche Achse beeinflusst `justify-content`?
`justify-content` beeinflusst die **Hauptachse** (row → horizontal, column → vertikal).
---

---

# **Teil 4 – Align Items **

## **Aufgabe 4 — Vertikale Ausrichtung üben**

Erstelle:

```html
<div class="bar">
  <div class="tall">Tall</div>
  <div>Small</div>
</div>
```

Setze:

* Containerhöhe: `height: 150px`
* `align-items: center`

---

### **Frage 4**

Was macht `align-items`?
`align-items` steuert die **Ausrichtung auf der Querachse** (cross axis).
---

---

# **Teil 5 – flex: grow / shrink / basis**

## **Aufgabe 5 — Items proportional verteilen**

Nutze:

```html
<div class="layout">
  <div class="main">Main</div>
  <div class="side">Sidebar</div>
</div>
```

Ziel:

* Main → `flex: 80%`
* Sidebar → `flex: 20%`

---


# **Teil 6 – align-self**

## **Aufgabe 6 — einzelnes Element ausrichten**

HTML:

```html
<div class="cards">
  <div>A</div>
  <div class="special">B</div>
  <div>C</div>
</div>
```

Ziel:

* `special` → individuelle vertikale Ausrichtung (`align-self: flex-end`)

---

### **Frage 6**

Warum ist `align-self` nützlich?
Weil es **ein einzelnes Flex-Item unabhängig von den anderen** auf der Querachse ausrichtet — ideal für Sonderfälle.
---
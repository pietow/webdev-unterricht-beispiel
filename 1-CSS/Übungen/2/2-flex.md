#  **Flexbox-Übung: Hauptbereich & Seitenbereich**

# **TEIL 1 — Grundlayout erstellen (10 Minuten)**

## **Aufgabe**

Erstelle die HTML-Struktur für ein zweispaltiges Layout:

* Ein `<main class="layout">`
* Im Inneren:

  * `<section class="content-main">` (Hauptbereich)
  * `<aside class="content-sidebar">` (Seitenbereich)

### **HTML-Vorgabe**

```html
<main class="layout">
  <section class="content-main">
    <h2>Main Content</h2>
    <p>Lorem ipsum…</p>
  </section>

  <aside class="content-sidebar">
    <h3>Sidebar</h3>
    <p>Additional info…</p>
  </aside>
</main>
```

---

### **Frage 1**

Warum wird die Klasse `layout` auf **main** gesetzt und nicht auf die inneren Elemente?
Weil **main** der Flex-Container wird.
Die inneren Elemente sollen **Flex-Items** sein → dafür muss der Container das Flex-Layout haben.

```css
.layout {
  display: flex;
}
```


# **TEIL 2 — Flex aktivieren & horizontales Layout **

## **Aufgabe**

Setzte die Flexbox so, sodass Hauptbereich und Sidebar **nebeneinander** stehen.


### **Frage 2**

Was bedeutet `flex-direction: row`?

Die Flex-Items werden **von links nach rechts** angeordnet.
Die Hauptachse ist **horizontal**.

---

# **TEIL 3 — Seitenbereich nach unten mit column**

## **Aufgabe**

Ändere das Layout so, dass die Sidebar **unter** dem Hauptbereich steht (mobile Layout), ohne das HTML zu ändern.


### **Frage 3**

Was passiert mit der Haupt- und Querachse bei `flex-direction: column`?
* Hauptachse wird **vertikal**
* Querachse wird **horizontal**

# **TEIL 4 — Zurück zu 2 Spalten + Seitenbereich schmaler**

## **Aufgabe**

Stelle wieder **row** her und steuere die Breiten mit der **`flex`-Property**:

* Hauptbereich: nimmt viel Platz → `flex: 3`
* Sidebar: kleiner → `flex: 1`


### **Kleine Code-Frage 4 — `flex`-Property**

**Was bedeutet konkret `flex: 3`?**

Kurzschreibweise für:

```
flex-grow: 3;
flex-shrink: 1;
flex-basis: 0%;
```

→ Das Element bekommt **dreimal so viel freien Platz wie ein Element mit `flex: 1`**.


### **Kleine Code-Frage 5 — Verhältnis verstehen**

Wenn `content-main` `flex: 3` hat und `content-sidebar` `flex: 1`, wie teilt sich der verfügbare Platz auf?

* Main: **3 Teile = 75 %**
* Sidebar: **1 Teil = 25 %**
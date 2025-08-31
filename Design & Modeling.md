# 📐 Data Warehouse Design & Modeling

Dieses Dokument fasst die wichtigsten Konzepte, Methoden und Best Practices für das **Design von Data Warehouses** zusammen. Grundlage sind die Werke von **Kimball** (Dimensional Modeling) und **Inmon**, ergänzt um moderne Ansätze aus der Praxis.

---

## 📐 Zentrale Konzepte & Methoden

### **Star Schema vs. ERM (OLTP)**

* **ERM (Entity-Relationship-Modell)**: Wird in **OLTP-Systemen** (z. B. ERP, CRM) verwendet. Ziel: **Datenintegrität und Normalisierung** (3NF). Viele Tabellen, viele Beziehungen, Fokus auf Transaktionssicherheit.
* **Star Schema**: Wird in **OLAP-Systemen/DWH** genutzt. Ziel: **einfache Abfragen und schnelle Aggregationen**. Wenige Tabellen, klare Trennung in **Fact Tables** (Zahlenwerte, Kennzahlen) und **Dimension Tables** (Beschreibungen, Attribute).

---

### **Star Schema: Facts & Dimensions**

* **Fact Tables**: Enthalten **Metriken/Kennzahlen** (z. B. Umsatz, Menge, Kosten). Typischerweise sehr groß.
* **Dimension Tables**: Beschreiben die Fakten durch Attribute (z. B. Produkt, Kunde, Zeit, Region). Relativ klein, dafür in Abfragen stark genutzt.

---

### **What is a Fact, what is a Dimension?**

* **Fact** = „Was wird gemessen?“ → Zahlen, Mengen, Werte (z. B. Umsatz, Retouren, Lagerbestand).
* **Dimension** = „In welchem Kontext?“ → Beschreibende Attribute, die das Fact einordnen (z. B. Produktkategorie, Kalenderdatum, Kundensegment).

---

### **What is Dimensional Modeling?**

* Methodik (Kimball-Schule) für den Aufbau von DWHs.
* Prinzipien:

  * Definiere **Geschäftsprozesse** (Sales, Inventory, Claims …).
  * Bestimme die **Kennzahlen (Facts)**.
  * Leite die dazugehörigen **Dimensionen** ab.
  * Baue daraus **Star Schemas**, die für Analysten verständlich und performant sind.

---

### **Denormalizing Dimensions**

* Normalisierung = Aufteilung in viele kleine Tabellen (redundanzfrei).
* Im DWH werden Dimensionen bewusst **denormalisiert**, um **einfache Abfragen** zu ermöglichen (z. B. Kundendaten + Region + Branche in einer Dimensionstabelle).
* Vorteil: Analysten müssen nicht mehrere Tabellen joinen.
* Nachteil: Redundanzen in den Dimensionen (z. B. gleiche Region mehrfach gespeichert).

---

### **Surrogate Keys – warum keine Primärschlüssel?**

* In OLTP werden **natürliche Schlüssel** (z. B. Kundennummer, Artikelnummer) genutzt.
* Im DWH werden stattdessen **Surrogate Keys** (künstliche, meist **Integer IDs**) eingesetzt.
* Vorteile:

  * Stabil auch bei Änderungen von Geschäfts-IDs (z. B. Kunde fusioniert, Artikelnummer wechselt).
  * Effizientere Joins (Integer statt String).
  * Ermöglicht SCDs (Historisierung) → gleiche Kundennummer kann mehrfach vorkommen, aber mit unterschiedlichen Zeitintervallen.

---

### **Identify the Facts → Die 7W-Fragen**

Um die **richtigen Kennzahlen** zu definieren, helfen die **7W-Fragen**:

* **Who** – Welche Kunden, Nutzer oder Organisationen sind beteiligt?
* **What** – Was genau wird gemessen (z. B. Umsatz, Verkäufe)?
* **When** – Zeitdimension: wann tritt das Ereignis auf?
* **Where** – Ort, Region, Filiale, Kanal.
* **How many** – Welche Mengen/Werte (Kennzahlen).
* **Why** – Geschäftlicher Grund oder Kontext (z. B. Rabattaktion).
* **How** – Über welchen Prozess/Workflow entsteht das Fact?

---

### **Declare the Grain (Detail-Level festlegen)**

* „Grain“ = **Detailstufe, auf der Daten im Fact Table gespeichert werden.**
* Beispiele:

  * Transaktionsebene (jede einzelne Bestellung)
  * Tagesebene (aggregiert pro Tag)
  * Monatsebene (aggregiert pro Monat)
* Wichtig: Das Grain muss **klar und eindeutig** definiert sein.
* Fehler: Mischung verschiedener Granularitäten in einem Fact Table → führt zu Inkonsistenzen.

---

### **Star Schema vs. Snowflake Schema**

* **Star Schema**: Dimensionen sind **nicht normalisiert**, alles in einer Tabelle. → Schnell, übersichtlich.
* **Snowflake Schema**: Dimensionen sind teilweise **normalisiert** (z. B. Produkt → Produktkategorie → Abteilung). → Speicheroptimierung, aber komplexere Joins.
* Best Practice: **Star Schema bevorzugen**, Snowflake nur wenn unbedingt nötig (z. B. sehr große Dimensionen).

---

## ⏳ Slowly Changing Dimensions (SCD)

### **Überblick**

* Dimensionen ändern sich über die Zeit (z. B. Kunde zieht um, Produkt bekommt neue Kategorie).
* Herausforderung: Historie aufbewahren oder überschreiben?

### **Typen**

* **Type 1 – Overwrite / Do Nothing**

  * Alte Werte werden überschrieben.
  * Keine Historie.
  * Beispiel: Rechtschreibfehler im Namen korrigieren.

* **Type 2 – Keep Full History**

  * Alte Werte bleiben erhalten.
  * Neue Zeile mit neuem Surrogate Key.
  * Beispiel: Kunde zieht in eine andere Stadt → alte Adresse bleibt in der Historie.

* **Type 3 – Keep Limited History**

  * Alte Werte werden in **zusätzlichen Spalten** gespeichert (z. B. `PreviousCity`).
  * Nur begrenzte Historie.
  * Beispiel: Max. eine alte Adresse aufbewahren.

---

## 📊 KPI-Design

* **KPI (Key Performance Indicator)** = abgeleitete Kennzahl zur Bewertung von Prozessen oder Strategien.
* Ableitung: Facts → Business-Fragen.
* Beispiele:

  * Umsatzwachstum pro Monat
  * Retourenquote (%)
  * Durchschnittlicher Bestellwert
  * Lagerumschlagshäufigkeit
* Wichtig: KPIs sollten immer einen **klaren Business-Bezug** haben, nicht nur eine nackte Zahl.

---

## 🔹 Erweiterte Konzepte (Advanced Modeling Concepts)

### **Faktenarten (Types of Facts)**

* **Additive Facts** – summierbar über alle Dimensionen (z. B. Umsatz).
* **Semi-Additive Facts** – nur teilweise summierbar (z. B. Kontostand summierbar über Kunden, aber nicht über Zeit).
* **Non-Additive Facts** – nicht summierbar, nur berechenbar (z. B. Prozentsätze, Quoten).

---

### **Faktentabellen-Varianten**

* **Transaction Fact Table** – detailgenaue Transaktionen (jede Bestellung, jeder Anruf).
* **Snapshot Fact Table** – Momentaufnahmen (z. B. Monatsendbestand).
* **Accumulating Snapshot** – Prozessfortschritt (z. B. Bestellung → Versand → Zahlung).

---

### **Zeitdimension (Time Dimension)**

* Eine **explizite Kalendertabelle** ist Best Practice.
* Enthält Attribute wie: Jahr, Quartal, Monat, Woche, Feiertage, Geschäftsjahr, Arbeitstage.
* Erleichtert Zeitreihenanalysen und Zeitvergleiche (YoY, MoM).

---

### **Conformed Dimensions**

* Wiederverwendete Dimensionen in mehreren Star Schemas (z. B. `Date`, `Customer`, `Product`).
* Vorteil: **Konsistenz** in Analysen über mehrere Fachbereiche hinweg.

---

### **Junk Dimensions**

* Bündelung kleiner Attribute (z. B. Flags wie „PromoFlag“, „OnlineOrderFlag“).
* Ziel: **Fact Tables schlank halten**.

---

### **Degenerate Dimensions (DD)**

* Dimension ohne eigene Tabelle.
* Attribut (z. B. `OrderNumber`) wird direkt in die Fact Table integriert.

---

### **Bridge Tables (Many-to-Many Relationships)**

* Behandlung von M\:N-Beziehungen zwischen Dimensionen (z. B. Kunde ↔ Konto, Student ↔ Kurs).
* Lösen Probleme bei Aggregationen und Mehrfachzuordnungen.

---

### **Data Vault vs. Dimensional Modeling**

* **Data Vault**: Integrationsorientiert, stark normalisiert (Hub, Link, Satellite).
* **Dimensional Modeling (Kimball)**: Analyseorientiert, denormalisiert (Star Schema).
* Moderne Architekturen kombinieren beides: Data Vault als **Raw Vault**, Star Schema für **Data Marts**.

---

### **ETL/ELT-Designprinzipien**

* Trennung in **Staging → Core DWH → Data Marts**.
* Automatisierte **Datenqualitäts-Checks**.
* Metadaten-gesteuerte ETL-Prozesse für Skalierbarkeit.

---

### **Performance & Best Practices**

* Grain klar definieren, Mischgranularitäten vermeiden.
* Surrogate Keys mit Indexierung nutzen.
* Partitionierung großer Fact Tables.
* Automatisiertes SCD-Handling.

---

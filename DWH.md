# 📚 Data Warehouse – Knowledge Base (Round-up)

## 🔹 Data Warehouse – Basics & Concepts

* [AltexSoft – Data Warehouse Architecture](https://www.altexsoft.com/blog/data-warehouse-architecture/)
* [Databricks – What is a Data Warehouse?](https://www.databricks.com/de/glossary/data-warehouse)
* [SAP – What is a Data Warehouse?](https://www.sap.com/austria/products/data-cloud/datasphere/what-is-a-data-warehouse.html)
* [Technikum Wien – Was ist ein Data Warehouse?](https://academy.technikum-wien.at/ratgeber/was-ist-ein-data-warehouse/)

---

## 🔹 DWH Design & Modeling

**📖 Literatur / Bücher**

* *The Data Warehouse Toolkit: The Definitive Guide to Dimensional Modeling* (Kimball, 3rd Edition)
* *Agile Data Warehouse Design: Collaborative Dimensional Modeling, from Whiteboard to Star Schema* (Lawrence Corr, Jim Stagnitto)

**📐 Zentrale Konzepte & Methoden**

* Star Schema vs. ERM (OLTP)
* Star Schema: Facts & Dimensions
* What is a Fact, what is a Dimension?
* What is Dimensional Modeling?
* Denormalizing Dimensions
* Surrogate Keys – warum keine Primärschlüssel?
* Identify the Facts → Die 7W-Fragen (Who, What, When, Where, How many, Why, How)
* Declare the Grain (Detail-Level festlegen)
* Star Schema vs. Snowflake Schema

**⏳ Slowly Changing Dimensions (SCD)**

* Überblick: SCD als zentrale DWH-Herausforderung
* Typen:

  * **Type 1** – Overwrite / Do Nothing (keine Historie)
  * **Type 2** – Keep Full History (Versionshistorie)
  * **Type 3** – Keep Limited History (z. B. Vorher/Nachher-Spalte)

**📊 KPI-Design**

* Key Performance Indicators → Ableitung aus Facts & Business-Fragestellungen

---

## 🔹 OLAP & Analysis Services

* [IBM – OLAP](https://www.ibm.com/de-de/think/topics/olap)
* [Microsoft Learn – OLAP Guide (Azure Architecture)](https://learn.microsoft.com/de-de/azure/architecture/data-guide/relational-data/online-analytical-processing)
* [Microsoft Learn – SSAS Overview](https://learn.microsoft.com/de-de/analysis-services/ssas-overview?view=sql-analysis-services-2025)
* [Microsoft Learn – Analysis Services Overview](https://learn.microsoft.com/de-de/analysis-services/analysis-services-overview?view=sql-analysis-services-2025)
* [Microsoft Learn – Install SQL Server Analysis Services](https://learn.microsoft.com/de-de/analysis-services/instances/install-windows/install-analysis-services?view=sql-analysis-services-2025)
* [Microsoft Learn – Install SQL Server Integration Services (SSIS)](https://learn.microsoft.com/de-de/sql/integration-services/install-windows/install-integration-services?view=sql-server-ver16)

---

## 🔹 Power BI – Modeling, Security & DAX

* [Microsoft Learn – Star Schema in Power BI](https://learn.microsoft.com/en-us/power-bi/guidance/star-schema)
* [Microsoft Learn – Row-Level Security in Fabric/Power BI](https://learn.microsoft.com/en-us/fabric/security/service-admin-row-level-security)
* [Microsoft Learn – Visual Calculations in Power BI](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-visual-calculations-overview)
* [Microsoft Learn – DAX INFO.VIEWMEASURES Function](https://learn.microsoft.com/en-us/dax/info-view-measures-function-dax)
* [DAX Guide – MAX Function](https://dax.guide/max/)

---

## 🔹 Community & Blogs

* [HandsOnData – How to Structure Transformations](https://handsondata.substack.com/p/how-to-structure-your-data-transformations?triedRedirect=true)
* [Microsoft Fabric Community](https://community.fabric.microsoft.com/)
* [Fabric Community – VS 2019 Tabular Model Explorer Disabled](https://community.fabric.microsoft.com/t5/Developer/Visual-Studio-2019-Tabular-Model-explorer-disabled/m-p/1969458)

---

## 🔹 Installations, Samples & Setup

* [Microsoft Learn – AdventureWorks Sample DB](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms)

---

**Komplette Rundumsicht über DWH**:

1. Grundkonzepte
2. Design/Modellierung (Kimball, Corr/Stagnitto, SCD, Keys, KPIs)
3. OLAP/SSAS für Analyse
4. Power BI/DAX für Frontend & Self-Service BI
5. Community/Blogs für Praxis
6. Installationen & Demo-Daten für Übungen

---

Willst du, dass ich dir das Ganze auch als **strukturierte Markdown-Datei (`dwh_resources.md`)** baue, die du direkt in Git oder dein Notion/Wiki übernehmen kannst?

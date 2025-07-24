

use workdb

Select * from dbo._DWH_FRAGEN_D_ANLAGEN

Select * from dbo._DWH_FRAGEN_D_DATUM

select * from dbo._DWH_FRAGEN_F_STROM

select * from dbo._DWH_FRAGEN_F_STROM_PROGNOSE

----

select *
into Anlagen
from dbo._DWH_FRAGEN_D_ANLAGEN


Select * 
into Datum
from dbo._DWH_FRAGEN_D_DATUM

select * 
into Strom
from dbo._DWH_FRAGEN_F_STROM

select * 
into Prognose
from dbo._DWH_FRAGEN_F_STROM_PROGNOSE

----

/*
IF OBJECT_ID('tempdb..#Answer1') IS NOT NULL
    DROP TABLE #Answer1


Select 
	'Kategrorie' = KATEGORIE_ID,
	'Auswertungsgruppe' = AUSWERTUNGSGRUPPE_ID,
	'Standort' = STANDORT_ID,
	'Kraftwerk' = KRAFTWERK_ID
into #Answer1
from Anlagen
where KRAFTWERK_NAME = 'KWK-Park Simmering 1' and TEILANLAGE_NAME not like 'gesamtes Kraftwerk SIM-SIM1'
group by KATEGORIE_ID, AUSWERTUNGSGRUPPE_ID, STANDORT_ID, KRAFTWERK_ID

Select * 
from #Answer1

*/
------------------------------
------------------------------
------------------------------

---------------------
/* Create Funktion */
---------------------

/*
CREATE FUNCTION dbo.fn_kWh_to_GWh (@kWh FLOAT)
RETURNS FLOAT
AS
BEGIN
    RETURN ROUND(@kWh / 1000000.0, 2)
END


CREATE FUNCTION dbo.fn_percentage (@obtained FLOAT, @total FLOAT)
RETURNS FLOAT
AS
BEGIN
    RETURN ROUND(@obtained/@total * 100, 2)
END
*/




-- 1.	Welche Teilanlagen gehören zum Kraftwerk KWK-Park Simmering 1? Welche IDs für Kategorie, Auswertungsgruppe, Standort und Kraftwerk hat das Kraftwerk?


Select 
	'Teilanlage_ID' = Teilanlage_ID,
	'Teilanlage_name' = Teilanlage_name,
	'KATEGORIE_ID' = KATEGORIE_ID,
	'AUSWERTUNGSGRUPPE_ID' = AUSWERTUNGSGRUPPE_ID,
	'STANDORT_ID' = STANDORT_ID,
	'KRAFTWERK_ID' = KRAFTWERK_ID
from Anlagen a
where 
	KRAFTWERK_NAME = 'KWK-Park Simmering 1' and 
	TEILANLAGE_NAME not like 'gesamtes Kraftwerk SIM-SIM1'


------------------------------
------------------------------
------------------------------

-----------
-- Pivot --
-----------

		select  d.MONAT_NAME, sum(s.EINSPEISUNG_IST) 'Gesamt_Strom'
		from Anlagen a
		join Prognose p on (p.ANLAGEN_KATEGORIE_ID = a.ANLAGEN_KATEGORIE_ID)
		join Strom s on (s.ANLAGEN_KATEGORIE_ID = p.ANLAGEN_KATEGORIE_ID)
		join Datum d on (d.JAHR_ID = s.JAHR_ID and d.MONAT_ID = s.MONAT_ID and QUARTAL_NAME = '2021 Q1')
		where KRAFTWERK_NAME = 'KWK-Park Simmering 1'  and TEILANLAGE_NAME not like 'gesamtes Kraftwerk SIM-SIM1' 
		group by d.MONAT_NAME
		order by d.MONAT_NAME

		Select 
				'2021-01' = SUM(CASE WHEN d.MONAT_NAME = '2021-01' THEN s.EINSPEISUNG_IST ELSE 0 END),
				'2021-02' = SUM(CASE WHEN d.MONAT_NAME = '2021-02' THEN s.EINSPEISUNG_IST ELSE 0 END),
				'2021-03' = SUM(CASE WHEN d.MONAT_NAME = '2021-03' THEN s.EINSPEISUNG_IST ELSE 0 END)
		from Anlagen a
		join Prognose p on (p.ANLAGEN_KATEGORIE_ID = a.ANLAGEN_KATEGORIE_ID)
		join Strom s on (s.ANLAGEN_KATEGORIE_ID = p.ANLAGEN_KATEGORIE_ID)
		join Datum d on (d.JAHR_ID = s.JAHR_ID and d.MONAT_ID = s.MONAT_ID and QUARTAL_NAME = '2021 Q1')
		where KRAFTWERK_NAME = 'KWK-Park Simmering 1'  and TEILANLAGE_NAME not like 'gesamtes Kraftwerk SIM-SIM1' 

----
----


-- 2.	Wie viel Strom ist zur Einspeisung geplant, prognostiziert und tatsächlich eingespeist worden mit Ende März 2021 (year-to-date) im Kraftwerk KWK-Park Simmering 1. 
-- iBitte die Strommenge in GWh angeben.

select a.TEILANLAGE_NAME, p.PROGNOSE, p.PROGNOSE_Q1, s.EINSPEISUNG_IST, s.EINSPEISUNG_PLAN, d.MONAT_NAME, d.QUARTAL_NAME
from _DWH_FRAGEN_D_ANLAGEN a
join _DWH_FRAGEN_F_STROM_PROGNOSE p on (p.ANLAGEN_KATEGORIE_ID = a.ANLAGEN_KATEGORIE_ID)
join _DWH_FRAGEN_F_STROM s on (s.ANLAGEN_KATEGORIE_ID = p.ANLAGEN_KATEGORIE_ID)
join _DWH_FRAGEN_D_DATUM d on (d.JAHR_ID = s.JAHR_ID and d.MONAT_ID = s.MONAT_ID and QUARTAL_NAME = '2021 Q1')
where KRAFTWERK_NAME = 'KWK-Park Simmering 1' 
order by d.MONAT_NAME


-- Antwort Gesamtanlage mit Update: --

select a.idAnlagen, a.TEILANLAGE_ID, a.TEILANLAGE_NAME, p.PROGNOSE, p.PROGNOSE_Q1, s.EINSPEISUNG_IST, s.EINSPEISUNG_PLAN, d.MONAT_NAME, sub.*
-- update s set EINSPEISUNG_IST = sub.Gesamter_Strom_pro_Monat
from Anlagen a
join Prognose p on (p.ANLAGEN_KATEGORIE_ID = a.ANLAGEN_KATEGORIE_ID)
join Strom s on (s.ANLAGEN_KATEGORIE_ID = p.ANLAGEN_KATEGORIE_ID)
join Datum d on (d.JAHR_ID = s.JAHR_ID and d.MONAT_ID = s.MONAT_ID and QUARTAL_NAME = '2021 Q1')
join (	
		select  d.MONAT_NAME, 
				sum(s.EINSPEISUNG_IST) 'Gesamter_Strom_pro_Monat'
		-- Select a.TEILANLAGE_NAME, d.Monat_Name, s.EINSPEISUNG_IST
		from Anlagen a
		join Prognose p on (p.ANLAGEN_KATEGORIE_ID = a.ANLAGEN_KATEGORIE_ID)
		join Strom s on (s.ANLAGEN_KATEGORIE_ID = p.ANLAGEN_KATEGORIE_ID)
		join Datum d on (d.JAHR_ID = s.JAHR_ID and d.MONAT_ID = s.MONAT_ID and QUARTAL_NAME = '2021 Q1')
		where KRAFTWERK_NAME = 'KWK-Park Simmering 1' and TEILANLAGE_NAME not like 'gesamtes Kraftwerk SIM-SIM1' 
		group by d.MONAT_NAME
	) sub on (sub.MOnat_name = d.MONAT_NAME)
where KRAFTWERK_NAME = 'KWK-Park Simmering 1' and TEILANLAGE_NAME = 'gesamtes Kraftwerk SIM-SIM1' 
order by d.MONAT_NAME




--  Wie viel Strom ist zur Einspeisung geplant, prognostiziert und tatsächlich eingespeist worden mit Ende März 2021 (year-to-date) im Kraftwerk KWK-Park Simmering 1. 
--  Bitte die Strommenge in GWh angeben.

select 
	a.TEILANLAGE_NAME,
	d.Quartal_Name,
	Geplant = dbo.fn_kWh_to_GWh(sum(s.EINSPEISUNG_PLAN)),
	PROGNOSE_Q1 = dbo.fn_kWh_to_GWh(p.PROGNOSE_Q1), 
	Produziert = dbo.fn_kWh_to_GWh(sum(s.EINSPEISUNG_IST))
from Anlagen a
join Prognose p on (p.ANLAGEN_KATEGORIE_ID = a.ANLAGEN_KATEGORIE_ID)
join Strom s on (s.ANLAGEN_KATEGORIE_ID = p.ANLAGEN_KATEGORIE_ID)
join Datum d on (d.JAHR_ID = s.JAHR_ID and d.MONAT_ID = s.MONAT_ID and QUARTAL_NAME = '2021 Q1')
where KRAFTWERK_NAME = 'KWK-Park Simmering 1'  and TEILANLAGE_NAME = 'gesamtes Kraftwerk SIM-SIM1' 
group by a.TEILANLAGE_NAME, d.Quartal_Name, p.PROGNOSE_Q1

------------------------------
------------------------------
------------------------------

/*
	 3.	Wie hoch war die tatsächliche Stromeinspeisung am Ende des ersten Quartals (year-to-date) für das Kraftwerk KWK-Park Simmering 1? 
		Wie hoch war die tatsächliche Stromeinspeisung Ende Februar (year-to-date) für das Kraftwerk KWK-Park Simmering 1? 
		Wie viel Prozent der tätsächlichen Einspeisung im ersten Quartal (year-to-date) waren Ende Februar (year-to-date) im Kraftwerk KWK-Park Simmering 1 erreicht? Bitte die Strommengen in GWh angeben.
*/

SELECT 
  Einspeisung_Jänner = dbo.fn_kWh_to_GWh(SUM(CASE WHEN d.MONAT_NAME = '2021-01' THEN s.EINSPEISUNG_IST ELSE 0 END)),
  Einspeisung_Februar = dbo.fn_kWh_to_GWh(SUM(CASE WHEN d.MONAT_NAME = '2021-02' THEN s.EINSPEISUNG_IST ELSE 0 END)),
  Einspeisung_Ende_Februar = dbo.fn_kWh_to_GWh(SUM(CASE WHEN d.MONAT_NAME in ('2021-01', '2021-02') THEN s.EINSPEISUNG_IST ELSE 0 END)),
  Einspeisung_März = dbo.fn_kWh_to_GWh(SUM(CASE WHEN d.MONAT_NAME = '2021-03' THEN s.EINSPEISUNG_IST ELSE 0 END)),
  Einspeisung_Gesamt_Q1 = dbo.fn_kWh_to_GWh(SUM(s.EINSPEISUNG_IST))
-- select idAnlagen, a.TEILANLAGE_ID, a.TEILANLAGE_NAME, p.PROGNOSE, p.PROGNOSE_Q1, s.EINSPEISUNG_IST, s.EINSPEISUNG_PLAN, d.MONAT_NAME
from Anlagen a
join Prognose p on (p.ANLAGEN_KATEGORIE_ID = a.ANLAGEN_KATEGORIE_ID)
join Strom s on (s.ANLAGEN_KATEGORIE_ID = p.ANLAGEN_KATEGORIE_ID)
join Datum d on (d.JAHR_ID = s.JAHR_ID and d.MONAT_ID = s.MONAT_ID and QUARTAL_NAME = '2021 Q1')
where KRAFTWERK_NAME = 'KWK-Park Simmering 1' and TEILANLAGE_NAME not like 'gesamtes Kraftwerk SIM-SIM1' 


-- Wie hoch war die tatsächliche Stromeinspeisung am Ende des ersten Quartals (year-to-date) für das Kraftwerk KWK-Park Simmering 1? 
-- Wie hoch war die tatsächliche Stromeinspeisung Ende Februar (year-to-date) für das Kraftwerk KWK-Park Simmering 1? 


SELECT 
  Einspeisung_Ende_Februar = dbo.fn_kWh_to_GWh(SUM(CASE WHEN d.MONAT_NAME in ('2021-01', '2021-02') THEN s.EINSPEISUNG_IST ELSE 0 END)),
  Einspeisung_Gesamt_Q1 = dbo.fn_kWh_to_GWh(SUM(s.EINSPEISUNG_IST))
-- select idAnlagen, a.TEILANLAGE_ID, a.TEILANLAGE_NAME, p.PROGNOSE, p.PROGNOSE_Q1, s.EINSPEISUNG_IST, s.EINSPEISUNG_PLAN, d.MONAT_NAME
from Anlagen a
join Prognose p on (p.ANLAGEN_KATEGORIE_ID = a.ANLAGEN_KATEGORIE_ID)
join Strom s on (s.ANLAGEN_KATEGORIE_ID = p.ANLAGEN_KATEGORIE_ID)
join Datum d on (d.JAHR_ID = s.JAHR_ID and d.MONAT_ID = s.MONAT_ID and QUARTAL_NAME = '2021 Q1')
where KRAFTWERK_NAME = 'KWK-Park Simmering 1' and TEILANLAGE_NAME not like 'gesamtes Kraftwerk SIM-SIM1' 



-- Wie viel Prozent der tätsächlichen Einspeisung im ersten Quartal (year-to-date) waren Ende Februar (year-to-date) im Kraftwerk KWK-Park Simmering 1 erreicht? 
-- Bitte die Strommengen in GWh angeben.

Select QUARTAL_NAME,
	   Einspeisung_Jänner_Februar, 
	   Einspeisung_Gesamt_Q1, 
	   Erreicht_in_Prozent = dbo.fn_percentage(Einspeisung_Jänner_Februar, Einspeisung_Gesamt_Q1)
from (
	SELECT 
	  d.QUARTAL_NAME,
	  Einspeisung_Jänner_Februar = dbo.fn_kWh_to_GWh(SUM(CASE WHEN d.MONAT_NAME in ('2021-01', '2021-02') THEN s.EINSPEISUNG_IST ELSE 0 END)),
	  Einspeisung_Gesamt_Q1 = dbo.fn_kWh_to_GWh(SUM(s.EINSPEISUNG_IST))
	from Anlagen a
	join Prognose p on (p.ANLAGEN_KATEGORIE_ID = a.ANLAGEN_KATEGORIE_ID)
	join Strom s on (s.ANLAGEN_KATEGORIE_ID = p.ANLAGEN_KATEGORIE_ID)
	join Datum d on (d.JAHR_ID = s.JAHR_ID and d.MONAT_ID = s.MONAT_ID and QUARTAL_NAME = '2021 Q1')
	where KRAFTWERK_NAME = 'KWK-Park Simmering 1' and TEILANLAGE_NAME not like 'gesamtes Kraftwerk SIM-SIM1' 
	group by d.QUARTAL_NAME
) sub


------------------------------
------------------------------
------------------------------

/*
	4.	Um die Entwicklung der tatsächlichen Stromeinspeisung des ersten Quartals 2021 im Kraftwerk KWK-Park Simmering 1 zu betrachten, soll eine Tabelle erstellt werden. 
	Diese soll zum einen angeben, wie hoch der aggregierte Wert für das Kraftwerk ist (pro Monat) und, zum anderen, um wie viel sich dieser aggregierte Wert von Monat zu Monat verändert. 
	Bitte die Strommengen in GWh angeben.
*/

IF OBJECT_ID('_DWH_FRAGEN_D_Entwicklung') IS NOT NULL
	drop table _DWH_FRAGEN_D_Entwicklung


Create Table _DWH_FRAGEN_D_Entwicklung (
	ENTWICKLUNG_ID INT IDENTITY(1,1) PRIMARY KEY, 
	Kraftwerk_ID bigint NOT NULL,
	Teilanlage_ID bigint NOT NULL,
	TEILANLAGE_NAME NVARCHAR(255), 
	EINSPEISUNG_IST_JAN_GWh float,
	EINSPEISUNG_DIFF_JAN_DEZ_GWh float,
	EINSPEISUNG_IST_FEB_GWh float,
	EINSPEISUNG_DIFF_FEB_JAN_GWh float,
	EINSPEISUNG_IST_MAR_GWh float,
	EINSPEISUNG_DIFF_MAR_FEB_GWh float
) on [primary]



-- Dezember Fehlt!
Insert into _DWH_FRAGEN_D_Entwicklung (Kraftwerk_ID, Teilanlage_ID, TEILANLAGE_NAME, EINSPEISUNG_IST_JAN_GWh, EINSPEISUNG_DIFF_JAN_DEZ_GWh,EINSPEISUNG_IST_FEB_GWh, EINSPEISUNG_DIFF_FEB_JAN_GWh,EINSPEISUNG_IST_MAR_GWh, EINSPEISUNG_DIFF_MAR_FEB_GWh)
Select 
		Kraftwerk_ID,
		Teilanlage_ID,
		TEILANLAGE_NAME, 
		GWh_Jan, 
		Differnz_Jan_Dez = NULL, 
		GWh_Feb, 
		Differnz_Feb_Jan = GWh_Feb - GWh_Jan , 
		GWh_Mär, 
		Differnz_Mär_Feb = GWh_Mär - GWh_Feb
from 
	(
	select 
		a.Kraftwerk_ID,
		a.Teilanlage_ID,
		a.TEILANLAGE_NAME, 
		GWh_Jan = dbo.fn_kWh_to_GWh(SUM(CASE WHEN d.MONAT_NAME = '2021-01' THEN s.EINSPEISUNG_IST ELSE 0 END)),
		GWh_Feb = dbo.fn_kWh_to_GWh(SUM(CASE WHEN d.MONAT_NAME = '2021-02' THEN s.EINSPEISUNG_IST ELSE 0 END)),
		GWh_Mär = dbo.fn_kWh_to_GWh(SUM(CASE WHEN d.MONAT_NAME = '2021-03' THEN s.EINSPEISUNG_IST ELSE 0 END))
	from Anlagen a
	join Prognose p on (p.ANLAGEN_KATEGORIE_ID = a.ANLAGEN_KATEGORIE_ID)
	join Strom s on (s.ANLAGEN_KATEGORIE_ID = p.ANLAGEN_KATEGORIE_ID)
	join Datum d on (d.JAHR_ID = s.JAHR_ID and d.MONAT_ID = s.MONAT_ID and QUARTAL_NAME = '2021 Q1')
	where a.KRAFTWERK_NAME = 'KWK-Park Simmering 1'  and a.TEILANLAGE_NAME = 'gesamtes Kraftwerk SIM-SIM1'
	group by a.Kraftwerk_ID, a.Teilanlage_ID, a.TEILANLAGE_NAME
	) sub 


Select *
from _DWH_FRAGEN_D_Entwicklung


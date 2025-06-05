-- check if the DR_NO column is a primary key 
SELECT * FROM crime GROUP BY DR_NO HAVING COUNT(*) >1;

-- check if the time for dates is always 12AM 
SELECT "Date Rptd"
FROM crime
WHERE substr("Date Rptd", instr("Date Rptd", ' ') + 1) != '12:00:00 AM';

SELECT "Date Occ"
FROM crime
WHERE substr("Date Occ", instr("Date Occ", ' ') + 1) != '12:00:00 AM';

--create new columns for the dates without the time (SQLite requires date to be stored in YYYY-MM-DD) 
SELECT
  -- Convert "Date Rptd" to YYYY-MM-DD
  substr("Date Rptd", 7, 4) || '-' || substr("Date Rptd", 1, 2) || '-' || substr("Date Rptd", 4, 2) AS reported_date,
  -- Convert "Date OCC" to YYYY-MM-DD
  substr("Date OCC", 7, 4) || '-' || substr("Date OCC", 1, 2) || '-' || substr("Date OCC", 4, 2) AS occurred_date
FROM crime;

-- combines the DATE OCC column and TIME OCC column (military time)  into SQLite datetime format YYYY-MM-DD HH:MM
SELECT
	substr("Date OCC", 7, 4) || '-' || substr("Date OCC", 1, 2) || '-' || substr("Date OCC", 4, 2) || " " || printf('%02d:%02d', "TIME OCC" / 100, "TIME OCC" % 100) as datetime_occ
FROM crime; 

-- check if AREA uniquely determines AREA NAME
SELECT 
	COUNT(DISTINCT("AREA NAME")) as tracker, 
	AREA 
FROM crime 
GROUP BY AREA; 

-- create a new table with AREA and AREA NAME
CREATE TABLE area_names AS 
SELECT DISTINCT "AREA", "AREA NAME" 
FROM crime; 

SELECT * FROM area_names; 

-- create a virtual table that computes the AREA code from Rpt Dist No. 
CREATE VIEW dist_area AS 
SELECT DISTINCT "Rpt Dist No", "Rpt Dist No" / 100 AS AREA
FROM crime;

select * from dist_area; 

-- check if Crm Cd is always contained in one of the Crm Cd n columns and is redundent 
SELECT "Crm Cd" FROM crime
WHERE "Crm Cd" IS NOT NULL 
AND NOT (
	"Crm Cd" = "Crm Cd" = "Crm Cd 1" OR
    "Crm Cd" = "Crm Cd 2" OR
    "Crm Cd" = "Crm Cd 3" OR
    "Crm Cd" = "Crm Cd 4"
  );
  
  -- separate the crime codes into another table. Drop the NULLs. 
CREATE TABLE codes AS 
SELECT "DR_NO", "Crm Cd 1" AS "Crm Cd" 
FROM crime 
WHERE "Crm Cd 1" IS NOT NULL

UNION ALL 

SELECT "DR_NO", "Crm Cd 2" AS "Crm Cd" 
FROM crime 
WHERE "Crm Cd 2" IS NOT NULL

UNION ALL 
 
SELECT "DR_NO", "Crm Cd 3" AS "Crm Cd" 
FROM crime 
WHERE "Crm Cd 3" IS NOT NULL
UNION ALL 

SELECT "DR_NO", "Crm Cd 4" AS "Crm Cd" 
FROM crime 
WHERE "Crm Cd 4" IS NOT NULL;

SELECT * FROM codes; 


-- creating other tables to minimize the number of columns per table 
CREATE TABLE code_desc AS 
SELECT DISTINCT ("Crm Cd") AS "Crm Cd", "Crm Cd Desc" 
FROM crime
WHERE "Crm Cd" IS NOT NULL; 

SELECT * FROM code_desc; 

CREATE TABLE premise AS 
SELECT DISTINCT ("Premis Cd") as "Premis Cd", "Premis Desc" 
FROM crime 
WHERE "Premis Cd" IS NOT NULL; 

SELECT * FROM premise; 

CREATE TABLE weapon AS 
SELECT DISTINCT ("Weapon Used Cd") as "Weapon Cd", "Weapon Desc" 
FROM crime 
WHERE "Weapon Used Cd" IS NOT NULL; 

SELECT * FROM weapon; 

CREATE TABLE status AS 
SELECT DISTINCT ("Status") as "Status", "Status Desc" 
FROM crime 
WHERE "Status" IS NOT NULL; 

SELECT * FROM status; 

-- What are the most popular weapons? 
SELECT 
	"Weapon Used Cd", 
	"Weapon Desc", 
	COUNT (*) as times_used
FROM crime 
WHERE "Weapon Used Cd" IS NOT NULL
GROUP by "Weapon Used Cd", "Weapon Desc" 
ORDER BY COUNT(*) DESC; 
-- Most Used: 400	STRONG-ARM (HANDS, FIST, FEET OR BODILY FORCE)	174777 times 
-- Least Used: 123	M1-1 SEMIAUTOMATIC ASSAULT RIFLE	1 time 

-- How many different weapons are there? 79 
SELECT COUNT(*) FROM weapon; 

-- What's the “most dangerous” neighborhood? 
SELECT 
	"AREA NAME", 
	COUNT (*) as number_of_crimes
FROM crime
GROUP BY "AREA NAME" 
ORDER BY COUNT (*) DESC; 
-- neighborhood with the highest number of crimes is central with 69674 crimes 

-- What’s the crime distribution over hours of the day? 
SELECT "TIME OCC" / 100 AS hour, COUNT(*) AS count
FROM crime
WHERE "TIME OCC" IS NOT NULL
GROUP BY hour
ORDER BY hour;

-- What’s the crime distribution over months of a year?
SELECT substr("Date Rptd", 1, 2) as month, Count(*) as count
FROM crime 
WHERE substr("Date Rptd", 1, 2) IS NOT NULL 
GROUP BY month 
ORDER BY month; 

-- Plot lan against LAT
SELECT 
  lat - (SELECT MIN(lat) FROM crime WHERE lat != 0.0) AS adj_lat,
  lon - (SELECT MIN(lon) FROM crime WHERE lon != 0.0) AS adj_lon
FROM crime
WHERE lat != 0.0 AND lon != 0.0;







-- ----------------------------------------------------------------------------Data Cleaning using MySQL
-- Fix column name from inport
Alter Table statistics rename column `ï»¿id` to `id`
 ;
 -- --------------------------------------------------------

-- Find and Remove Duplicates Income table
-- Identify Duplicates
SELECT id, count(id) as count
FROM income
GROUP BY id
Having count > 1
;

-- Create new unique column allowing delete query
SELECT *
FROM (
	SELECT row_id, id,
	ROW_NUMBER() OVER(PARTITION BY id) as row_num
	FROM income) as table1
Where row_num > 1
;
-- Delete Duplicates
DELETE FROM income WHERE
	row_id in (
	SELECT row_id
	FROM (
	SELECT row_id, id,
	ROW_NUMBER() OVER(PARTITION BY id) as row_num
	FROM income) as table1
	Where row_num > 1)
    ;
    -- --------------------------------------
    -- Find and Remove Duplicates Statistics table
-- Identify Duplicates
SELECT id, count(id) as count
FROM statistics
GROUP BY id
Having count > 1;
-- No Duplicates Found!
-- ------------------------------------------------
-- Standardizing data from a few columns next
update income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

update income
SET State_Name = 'Georgia'
WHERE State_Name = 'Georia';

UPDATE income
SET Place = 'Autaugaville' 
Where County = 'Autauga County'
AND City = 'Vinemont'
;

UPDATE income
Set Type = 'Borough'
WHERE Type = 'Boroughs';
-- ---------------------------------------------------
-- ------------------------------------------------------------------------------------- Exploratory Data Analysis (EDA)
-- First The sum of land and water for each state - Changing the order by or adding limit can show highest, lowest, top 20, etc...
SELECT State_Name, SUM(ALand) As Land, SUM(AWater) As Water
FROM income.income
GROUP BY State_Name
ORDER BY 2 DESC
;

-- Next I join 2 tables together to compare data, first average income and median by state
SELECT inc.State_Name, 
Round(AVG(Mean), 2) As Avg_Income, 
Round(AVG(Median), 2) As Avg_Median
FROM income inc
JOIN statistics sta
	on inc.id = sta.id
WHERE Mean <> 0
GROUP BY inc.State_Name;

-- Average income and median by county
SELECT inc.County, inc.State_ab, 
Round(AVG(Mean), 2) As Avg_Income, 
Round(AVG(Median), 2) As Avg_Median
FROM income inc
JOIN statistics sta
	on inc.id = sta.id
WHERE Mean <> 0
GROUP BY inc.County, inc.State_ab
Order By Avg_Income Desc;

-- Average income and median by area type
SELECT Type, 
Round(AVG(Mean), 2) As Avg_Income, 
Round(AVG(Median), 2) As Avg_Median
FROM income inc
JOIN statistics sta
	on inc.id = sta.id
WHERE Mean <> 0
GROUP BY Type;

-- Average income and median by land size
SELECT ALand, 
Round(AVG(Mean), 2) As Avg_Income, 
Round(AVG(Median), 2) As Avg_Median
FROM income inc
JOIN statistics sta
	on inc.id = sta.id
WHERE Mean <> 0
GROUP BY ALand;

-- Average income and median by water area size
SELECT AWater, 
Round(AVG(Mean), 2) As Avg_Income, 
Round(AVG(Median), 2) As Avg_Median
FROM income inc
JOIN statistics sta
	on inc.id = sta.id
WHERE Mean <> 0
GROUP BY AWater;

-- That is all for SQL on this one. As always, many more combos can be pulled these are just a few. It depends on objectives
-- Now I will take these joined tables and create visuals
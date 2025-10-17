SELECT *
FROM world_life_expectancy;

-- duplicates

SELECT Country, Year, concat(Country, Year), count(concat(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, concat(Country, Year)
HAVING count(concat(Country, Year)) > 1;

-- find Row_ID for duplicates
SELECT *
FROM (
SELECT Row_ID,
concat(Country, Year),
ROW_NUMBER() OVER (PARTITION BY concat(Country, Year) ORDER BY concat(Country, Year)) as Row_Num
FROM world_life_expectancy
) AS Row_table
WHERE Row_Num > 1
;

-- delete duplicates
DELETE FROM world_life_expectancy
WHERE
Row_ID IN (
SELECT ROW_ID
FROM (
SELECT Row_ID,
concat(Country, Year),
ROW_NUMBER() OVER (PARTITION BY concat(Country, Year) ORDER BY concat(Country, Year)) as Row_Num
FROM world_life_expectancy
) AS Row_table
WHERE Row_Num > 1
)
;

-- chceck status options
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> '';

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';


-- set empty status using country info
UPDATE world_life_expectancy table1
JOIN world_life_expectancy table2
ON table1.Country = table2.Country
SET table1.Status = 'Developing'
WHERE table1.Status = ''
AND table2.Status <> ''
AND table2.Status = 'Developing'
;

UPDATE world_life_expectancy table1
JOIN world_life_expectancy table2
ON table1.Country = table2.Country
SET table1.Status = 'Developed'
WHERE table1.Status = ''
AND table2.Status <> ''
AND table2.Status = 'Developed'
;
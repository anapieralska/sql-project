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

-- empty life expectancy
SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';

-- find 2018 life expectancy for Albania and Afghanistan, based on values from 2017 and 2019
SELECT table1.Country, table1.Year, table1.`Life expectancy`,
table2.Country, table2.Year, table2.`Life expectancy`,
table3.Country, table3.Year, table3.`Life expectancy`,
ROUND((table2.`Life expectancy` + table3.`Life expectancy`)/2,1) Prediction
FROM world_life_expectancy table1
JOIN world_life_expectancy table2
ON table1.Country = table2.Country
AND table1.Year = table2.Year - 1
JOIN world_life_expectancy table3
ON table1.Country = table3.Country
AND table1.Year = table3.Year + 1
WHERE table1.`Life expectancy` = '';


UPDATE  world_life_expectancy table1
JOIN world_life_expectancy table2
ON table1.Country = table2.Country
AND table1.Year = table2.Year - 1
JOIN world_life_expectancy table3
ON table1.Country = table3.Country
AND table1.Year = table3.Year + 1
SET table1.`Life expectancy` = ROUND((table2.`Life expectancy` + table3.`Life expectancy`)/2,1)
WHERE table1.`Life expectancy` = ''
;
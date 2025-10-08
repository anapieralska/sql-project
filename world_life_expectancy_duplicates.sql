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
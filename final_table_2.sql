SELECT *
FROM t_andrea_zemanova_project_SQL_primary_final tazpspf 
;

SELECT *
FROM countries c 
;

SELECT DISTINCT continent 
FROM countries c 
;
-- 8 radku


-- vyberu jen Evropske staty:
SELECT *
FROM countries c 
WHERE continent = 'Europe'
ORDER BY country, region_in_world 
;
-- 48 radku


SELECT *
FROM economies e 
;


SELECT DISTINCT country 
FROM economies e 
;


SELECT 
	c.continent,
	c.country,
	e.`year`, 
	e.GDP, 
	e.gini,
	e.population 
FROM countries AS c
LEFT JOIN economies AS e
	ON c.country = e.country 
WHERE c.continent = 'Europe' AND `year` BETWEEN 2006 AND 2018 AND e.country IS NOT NULL 
ORDER BY e.country, e.`year` 
;
-- 585 radku

-- predesly dotaz zapsan pomoci CTE:
WITH eco_coun AS (
	SELECT 
		c.country,
		c.continent 
	FROM countries AS c 
	WHERE c.continent = 'Europe'
)
SELECT 
	ec.continent,
	ec.country,
	e.`year`, 
	e.GDP, 
	e.gini,
	e.population 
FROM eco_coun AS ec
LEFT JOIN economies AS e
	ON e.country = ec.country  
WHERE e.country IS NOT NULL AND `year` BETWEEN 2006 AND 2018
ORDER BY e.country, e.`year`
;


-- vypocet poctu radku v CTE:
WITH eco_coun AS (
	SELECT 
		c.country,
		c.continent 
	FROM countries AS c 
	WHERE c.continent LIKE 'Europe'
)
SELECT 
	count(*)
FROM eco_coun AS ec
LEFT JOIN economies AS e
	ON e.country = ec.country 
WHERE e.country IS NOT NULL AND `year` BETWEEN 2006 AND 2018
ORDER BY e.country, e.`year`
;
-- 585 radku


CREATE OR REPLACE TABLE t_andrea_zemanova_project_SQL_secondary_final AS
WITH eco_coun AS (
	SELECT 
		c.country,
		c.continent 
	FROM countries AS c 
	WHERE c.continent LIKE 'Europe'
)
SELECT 
	ec.continent,
	ec.country,
	e.`year`, 
	e.GDP,
	e.gini,
	e.population 
FROM eco_coun AS ec
LEFT JOIN economies AS e
	ON e.country = ec.country  
WHERE e.country IS NOT NULL AND `year` BETWEEN 2006 AND 2018
ORDER BY e.country, e.`year`
;

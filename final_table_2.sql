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


SELECT *
FROM t_andrea_zemanova_project_SQL_primary_final tazpspf 
;



WITH CZE AS (
	SELECT 
		sec.country,
		sec.`year`,
		sec.GDP 
	FROM t_andrea_zemanova_project_SQL_secondary_final AS sec
	WHERE country = 'Czech Republic'
)
SELECT 
	CZE.country,
	prim.payroll_year,
	prim.industry,
	prim.industry_branch_code,
	prim.avg_value AS payroll_CZK,
	prim.food_code,
	prim.food,
	prim.avg_food_year AS food_price_CZK,
	CZE.GDP
FROM CZE
LEFT JOIN t_andrea_zemanova_project_SQL_primary_final AS prim
	ON prim.payroll_year = CZE.`year` 
;
	

-- spocitani radku daneho dotazu:
WITH CZE AS (
	SELECT 
		sec.country,
		sec.`year`,
		sec.GDP 
	FROM t_andrea_zemanova_project_SQL_secondary_final AS sec
	WHERE country = 'Czech Republic'
)
SELECT count(*)
FROM CZE
LEFT JOIN t_andrea_zemanova_project_SQL_primary_final AS prim
	ON prim.payroll_year = CZE.`year` 
;
-- 6498 radku

CREATE OR REPLACE VIEW v_andrea_zemanova_GDP AS
WITH CZE AS (
	SELECT 
		sec.country,
		sec.`year`,
		sec.GDP 
	FROM t_andrea_zemanova_project_SQL_secondary_final AS sec
	WHERE country = 'Czech Republic'
)
SELECT 
	CZE.country,
	prim.payroll_year,
	prim.industry,
	prim.industry_branch_code,
	prim.avg_value AS payroll_CZK,
	prim.food_code,
	prim.food,
	prim.avg_food_year AS food_price_CZK,
	CZE.GDP
FROM CZE
LEFT JOIN t_andrea_zemanova_project_SQL_primary_final AS prim
	ON prim.payroll_year = CZE.`year` 
;
-- 6498 radku

SELECT 
	payroll_year,
	food_code,
	food,
	food_price_CZK,
	GDP 
FROM (
	SELECT 
		payroll_year,
		industry,
		industry_branch_code,
		payroll_CZK,
		food_code,
		food,
		food_price_CZK, 
		GDP
	FROM v_andrea_zemanova_GDP vazg 
	ORDER BY payroll_year, food, industry_branch_code 
) AS food_sub
GROUP BY payroll_year, food_code, food, food_price_CZK, GDP
ORDER BY payroll_year, food
;


-- prumerne ceny vsech potravin v jednotlivych letech:
SELECT 
	payroll_year,
	round(avg(food_price_CZK),2) AS avg_food_price_CZK,
	GDP
FROM (
	SELECT 
		payroll_year,
		food_code,
		food,
		food_price_CZK,
		GDP 
	FROM (
		SELECT 
			payroll_year,
			industry,
			industry_branch_code,
			payroll_CZK,
			food_code,
			food,
			food_price_CZK, 
			GDP
		FROM v_andrea_zemanova_GDP vazg 
		ORDER BY payroll_year, food, industry_branch_code 
	) AS food_sub
	GROUP BY payroll_year, food_code, food, food_price_CZK, GDP
	ORDER BY payroll_year, food
) AS avg_food_price
WHERE payroll_year BETWEEN 2006 AND 2018
GROUP BY payroll_year
ORDER BY payroll_year
;


CREATE OR REPLACE VIEW v_andrea_zemanova_food_price_GDP AS 
SELECT 
	payroll_year,
	round(avg(food_price_CZK),2) AS avg_food_price_CZK,
	GDP
FROM (
	SELECT 
		payroll_year,
		food_code,
		food,
		food_price_CZK,
		GDP 
	FROM (
		SELECT 
			payroll_year,
			industry,
			industry_branch_code,
			payroll_CZK,
			food_code,
			food,
			food_price_CZK, 
			GDP
		FROM v_andrea_zemanova_GDP vazg 
		ORDER BY payroll_year, food, industry_branch_code 
	) AS food_sub
	GROUP BY payroll_year, food_code, food, food_price_CZK, GDP
	ORDER BY payroll_year, food
) AS avg_food_price
WHERE payroll_year BETWEEN 2006 AND 2018
GROUP BY payroll_year
ORDER BY payroll_year
;



-- vypocet prumernych mezd ze vsech odvetvi v jednotlivych letech
SELECT 
	payroll_year,
	round(avg(payroll_CZK),0) AS avg_payroll_CZK,
	GDP 
FROM (
	SELECT 
		payroll_year,
		industry,
		industry_branch_code,
		payroll_CZK,
		GDP
	FROM v_andrea_zemanova_GDP vazg 
	GROUP BY payroll_year, industry, industry_branch_code, payroll_CZK, GDP
	ORDER BY payroll_year, industry_branch_code 
) AS avg_payroll
GROUP BY payroll_year, GDP
ORDER BY payroll_year
;


CREATE OR REPLACE VIEW v_andrea_zemanova_payroll_GDP AS 
SELECT 
	payroll_year,
	round(avg(payroll_CZK),0) AS avg_payroll_CZK,
	GDP 
FROM (
	SELECT 
		payroll_year,
		industry,
		industry_branch_code,
		payroll_CZK,
		GDP
	FROM v_andrea_zemanova_GDP vazg 
	GROUP BY payroll_year, industry, industry_branch_code, payroll_CZK, GDP
	ORDER BY payroll_year, industry_branch_code 
) AS avg_payroll
GROUP BY payroll_year, GDP
ORDER BY payroll_year
;

-- vypocet procentualniho rozdilu HDP mezi jednotlivymi roky:
SELECT 
	food.payroll_year,
	food.avg_food_price_CZK,
	pay.avg_payroll_CZK,
	lag(pay.GDP, 1) OVER (ORDER BY payroll_year) AS GDP_prev_year,
	pay.GDP AS GDP_payroll_year,
	round(((pay.GDP - lag(pay.GDP, 1) OVER (ORDER BY payroll_year)) / lag(pay.GDP, 1) OVER (ORDER BY payroll_year)) * 100, 1) AS perc_diff_GDP
FROM v_andrea_zemanova_food_price_GDP AS food
LEFT JOIN v_andrea_zemanova_payroll_GDP AS pay 
	ON pay.payroll_year = food.payroll_year 
;


CREATE OR REPLACE VIEW v_andrea_zemanova_perc_diff_GDP AS 
SELECT 
	food.payroll_year,
	food.avg_food_price_CZK,
	pay.avg_payroll_CZK,
	lag(pay.GDP, 1) OVER (ORDER BY payroll_year) AS GDP_prev_year,
	pay.GDP AS GDP_payroll_year,
	round(((pay.GDP - lag(pay.GDP, 1) OVER (ORDER BY payroll_year)) / lag(pay.GDP, 1) OVER (ORDER BY payroll_year)) * 100, 1) AS perc_diff_GDP
FROM v_andrea_zemanova_food_price_GDP AS food
LEFT JOIN v_andrea_zemanova_payroll_GDP AS pay 
	ON pay.payroll_year = food.payroll_year 
;





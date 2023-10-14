SELECT 
	pay.payroll_year,
	pay.payroll_quarter, 
	ind.name AS industry,
	pay.industry_branch_code,
	pay.value,
	un.name AS unit,
	val.name AS `type`,
	cal.name AS calculation	
FROM czechia_payroll AS pay
LEFT JOIN czechia_payroll_calculation AS cal
	ON cal.code = pay.calculation_code 
LEFT JOIN czechia_payroll_industry_branch AS ind
	ON ind.code = pay.industry_branch_code 
LEFT JOIN czechia_payroll_unit AS un
	ON un.code = pay.unit_code 
LEFT JOIN czechia_payroll_value_type AS val
	ON val.code = pay.value_type_code
;


-- vytvoreni pohledu:

CREATE VIEW v_andrea_zemanova_payroll_complete AS
SELECT 
	pay.payroll_year,
	pay.payroll_quarter, 
	ind.name AS industry,
	pay.industry_branch_code,
	pay.value,
	un.name AS unit,
	val.name AS `type`,
	cal.name AS calculation	
FROM czechia_payroll AS pay
LEFT JOIN czechia_payroll_calculation AS cal
	ON cal.code = pay.calculation_code 
LEFT JOIN czechia_payroll_industry_branch AS ind
	ON ind.code = pay.industry_branch_code 
LEFT JOIN czechia_payroll_unit AS un
	ON un.code = pay.unit_code 
LEFT JOIN czechia_payroll_value_type AS val
	ON val.code = pay.value_type_code
;


SELECT count(*)
FROM v_andrea_zemanova_payroll_complete vazpc
;
-- 6880 radku celkem


SELECT DISTINCT (`type`)
FROM v_andrea_zemanova_payroll_complete vazpc 
;
-- Průměrný počet zaměstnaných osob
-- Průměrná hrubá mzda na zaměstnance



SELECT count(*)
FROM v_andrea_zemanova_payroll_complete vazpc 
WHERE `type` = 'Průměrný počet zaměstnaných osob'
;
-- 3440 radku



SELECT count(*)
FROM v_andrea_zemanova_payroll_complete vazpc 
WHERE `type` = 'Průměrná hrubá mzda na zaměstnance'
;
-- 3440 radku



SELECT count(*) AS count_fyzicky
FROM v_andrea_zemanova_payroll_complete vazpc 
WHERE calculation = 'fyzický' 
;
-- 3440 radku



SELECT count(*) AS count_prepocteny
FROM v_andrea_zemanova_payroll_complete vazpc 
WHERE calculation = 'přepočtený' 
;
-- 3440 radku



SELECT DISTINCT industry
FROM v_andrea_zemanova_payroll_complete vazpc 
;
-- 19 polozek + NULL

SELECT * 
FROM v_andrea_zemanova_payroll_complete vazpc 
WHERE `type` = 'Průměrná hrubá mzda na zaměstnance' AND calculation = 'přepočtený'
ORDER BY payroll_year, payroll_quarter,industry
;
-- rok 2000, 1Q, value = 11941


SELECT *
FROM v_andrea_zemanova_payroll_complete vazpc 
WHERE unit = 'Kč' AND calculation = 'přepočtený'
ORDER BY payroll_year, industry, payroll_quarter 
;
-- 11941 Kc, rok 2000, Q1, industry NULL
-- 13227 Kc, rok 2000, Q2, industry NULL
-- 12963 Kc, rok 2000, Q3, industry NULL
-- 14717 Kc, rok 2000, Q4, industry NULL


-- vytvoreni pohledu
CREATE VIEW v_andrea_zemanova_recounted_payroll AS 
SELECT *
FROM v_andrea_zemanova_payroll_complete vazpc 
WHERE unit = 'Kč' AND calculation = 'přepočtený'
ORDER BY payroll_year, industry, payroll_quarter 
;



SELECT *
FROM v_andrea_zemanova_recounted_payroll vazrp
;



SELECT count(*)
FROM v_andrea_zemanova_recounted_payroll vazrp
;
-- 1720 radku



-- vycistit od NULL hodnot v industry:
SELECT *
FROM v_andrea_zemanova_recounted_payroll vazrp 
WHERE industry IS NOT NULL 
;



SELECT count(*)
FROM v_andrea_zemanova_recounted_payroll vazrp 
WHERE industry IS NOT NULL 
;
-- 1634 radku



-- prumer platu pro dane odvetvi za rok:
SELECT 
	payroll_year,
	industry,
	industry_branch_code, 
	round(avg(value)) AS avg_value,
	unit 
FROM v_andrea_zemanova_recounted_payroll vazrp 
WHERE industry IS NOT NULL 
GROUP BY payroll_year, industry, industry_branch_code, unit 
ORDER BY payroll_year, industry_branch_code
;



-- vytvoreni pohledu pro industry:
CREATE VIEW v_andrea_zemanova_avg_payroll_industry AS
SELECT 
	payroll_year,
	industry,
	industry_branch_code, 
	round(avg(value)) AS avg_value,
	unit 
FROM v_andrea_zemanova_recounted_payroll vazrp 
WHERE industry IS NOT NULL 
GROUP BY payroll_year, industry, industry_branch_code, unit 
ORDER BY payroll_year, industry_branch_code
;


SELECT *
FROM v_andrea_zemanova_avg_payroll_industry vazapi 
;


SELECT count(*)
FROM v_andrea_zemanova_avg_payroll_industry vazapi 
;
-- 418 radku


-- sjednoceni tabulek czechia price plus pridruzene:
SELECT 
	pri.date_from AS 'year from',
	pri.date_to AS 'year to',
	pri.value AS price_in_CZK,
	pri.category_code AS food_code,
	cat.name AS food,
	pri.region_code,
	reg.name AS region,
	cat.price_value,
	cat.price_unit 
FROM czechia_price AS pri
LEFT JOIN czechia_price_category AS cat
	ON cat.code = pri.category_code 
LEFT JOIN czechia_region AS reg
	ON reg.code = pri.region_code 
;

CREATE VIEW v_andrea_zemanova_food_date AS 
SELECT 
	pri.date_from AS 'year from',
	pri.date_to AS 'year to',
	pri.value AS price_in_CZK,
	pri.category_code AS food_code,
	cat.name AS food,
	pri.region_code,
	reg.name AS region,
	cat.price_value,
	cat.price_unit 
FROM czechia_price AS pri
LEFT JOIN czechia_price_category AS cat
	ON cat.code = pri.category_code 
LEFT JOIN czechia_region AS reg
	ON reg.code = pri.region_code 
;


SELECT *
FROM v_andrea_zemanova_food_date
;


SELECT count(*)
FROM v_andrea_zemanova_food_date vazfd 
;
-- 108249 radku


SELECT *
FROM v_andrea_zemanova_food_date vazfd 
WHERE region_code IS NULL 
ORDER BY food, `year from` 
;


SELECT count(*)
FROM (
	SELECT *
	FROM v_andrea_zemanova_food_date vazfd 
	WHERE region_code IS NULL 
	ORDER BY food, `year from`
) AS count 
;
-- 7217 radku


-- vybrani hodnot, kde region_code is NULL 
SELECT *
FROM v_andrea_zemanova_food_date vazfd 
WHERE region_code IS NULL 
ORDER BY food, `year from` 
;


-- prumer cen potravin za rok s vybranim region_code IS NULL:
SELECT 
	YEAR(`year from`),
	food_code,
	food,
	price_value,
	price_unit,
	region_code,
	round(avg(price_in_CZK),2) AS avg_food_year
FROM (
	SELECT *
	FROM v_andrea_zemanova_food_date vazfd 
	WHERE region_code IS NULL 
	ORDER BY food, `year from` 
) AS sub 
GROUP BY 
	YEAR(`year from`),
	food_code,
	food,
	price_value,
	price_unit,
	region_code
ORDER BY food, `year from`
;



-- vytvoreni pohledu avg_food_year:
CREATE VIEW v_andrea_zemanova_avg_food_year_14 AS 
SELECT 
	YEAR(`year from`),
	food_code,
	food,
	price_value,
	price_unit,
	region_code,
	round(avg(price_in_CZK),2) AS avg_food_year
FROM (
	SELECT *
	FROM v_andrea_zemanova_food_date vazfd 
	WHERE region_code IS NULL 
	ORDER BY food, `year from` 
) AS sub 
GROUP BY 
	YEAR(`year from`),
	food_code,
	food,
	price_value,
	price_unit,
	region_code
ORDER BY food, `year from`
;


-- pocet radku IS NULL:
SELECT count(*) AS total_count_rows
FROM (
	SELECT 
	YEAR(`year from`),
	food_code,
	food,
	price_value,
	price_unit,
	region_code,
	round(avg(price_in_CZK),2) AS avg_food_year
	FROM (
		SELECT *
		FROM v_andrea_zemanova_food_date vazfd 
		WHERE region_code IS NULL 
		ORDER BY food, `year from` 
	) AS sub 
	GROUP BY 
		YEAR(`year from`),
		food_code,
		food,
		price_value,
		price_unit,
		region_code
	ORDER BY food, `year from`
) AS count_rows
;
-- 342 radku



-- vybrani nenulovych hodnot v region_code:
SELECT *
FROM v_andrea_zemanova_food_date vazfd 
WHERE region_code IS NOT NULL 
ORDER BY food, `year from` 
;


-- vypocitani prumernych cen potravin za rok pri zvoleni region_code IS NOT NULL:
SELECT 
	period,
	food_code,
	food,
	price_value,
	price_unit,
	round(avg(price_in_CZK),2) AS avg_food_year_confirmed
FROM (
	SELECT 
		year(`year from`) AS period,
		price_in_CZK,
		food_code,
		food,
		region,
		price_value,
		price_unit 
	FROM v_andrea_zemanova_food_date vazfd 
	WHERE region_code IS NOT NULL 
	ORDER BY food, YEAR(`year from`)
) AS sub 
GROUP BY period, food_code, food, price_value, price_unit
ORDER BY food, period 
;


-- vypocitani radku IS NOT NULL:
SELECT count(*) AS total_rows_count
FROM (
	SELECT 
		period,
		food_code,
		food,
		price_value,
		price_unit,
		round(avg(price_in_CZK),2) AS avg_year_price
	FROM (
		SELECT 
			year(`year from`) AS period,
			price_in_CZK,
			food_code,
			food,
			region_code,
			region,
			price_value,
			price_unit 
		FROM v_andrea_zemanova_food_date vazfd 
		WHERE region_code IS NOT NULL 
		ORDER BY food, YEAR(`year from`)
	) AS sub 
	GROUP BY period, food_code, food, price_value, price_unit
	ORDER BY food, period 
) AS count_rows
;
-- 342 radku


-- vytvoreni pohledu pro porovnani prumernych cen potravin za rok:
CREATE VIEW v_andrea_zemanova_avg_food_year_14_2 AS
SELECT 
	period,
	food_code,
	food,
	price_value,
	price_unit,
	round(avg(price_in_CZK),2) AS confirmed
FROM (
	SELECT 
		year(`year from`) AS period,
		price_in_CZK,
		food_code,
		food,
		region,
		price_value,
		price_unit 
	FROM v_andrea_zemanova_food_date vazfd 
	WHERE region_code IS NOT NULL 
	ORDER BY food, `year from`
) AS sub 
GROUP BY period, food_code, food, price_value, price_unit
ORDER BY food, period 
;


-- porovnani avg_food_year a avg_food_year_confirmed:
SELECT *
FROM v_andrea_zemanova_avg_food_year_14 vazafy 
JOIN v_andrea_zemanova_avg_food_year_14_2 vazafy2 
	ON vazafy2.avg_food_year_confirmed = vazafy.avg_food_year 
;
-- prumery souhlasi


-- po potvrzeni muzu pohled smazat, uz nebudu potrebovat:
DROP VIEW v_andrea_zemanova_avg_food_year_14_2
;


SELECT *
FROM v_andrea_zemanova_avg_food_year_14 vazafy 
;


SELECT 
	`YEAR(``year from``)`  AS period,
	food_code,
	food,
	price_value,
	price_unit,
	avg_food_year 
FROM v_andrea_zemanova_avg_food_year_14 vazafy 
;


-- vytvoreni pohledu price_food_year:
CREATE VIEW v_andrea_zemanova_food_avg_year AS
SELECT 
	`YEAR(``year from``)`  AS period,
	food_code,
	food,
	price_value,
	price_unit,
	avg_food_year 
FROM v_andrea_zemanova_avg_food_year_14 vazafy 
;



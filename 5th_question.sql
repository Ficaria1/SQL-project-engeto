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

-- vypocet procentualniho narustu HDP mezi jednotlivymi roky:
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


SELECT *
FROM v_andrea_zemanova_perc_diff_GDP vazpdg 
;


SELECT 
	gdp.payroll_year,
	gdp.avg_payroll_CZK,
	pay.perc_diff_payroll,
	pri.year_avg_food_price,
	pri.perc_price_diff,
	gdp.GDP_payroll_year,
	gdp.perc_diff_GDP,
	CASE 
		WHEN gdp.perc_diff_GDP > 5 
			AND pay.perc_diff_payroll > 5 AND pri.perc_price_diff > 5 
		THEN 'influence within the same year'
		ELSE "can't influence"
	END GDP_impact_current_year,
	CASE 
		WHEN gdp.perc_diff_GDP > 5
			AND (lead(pay.perc_diff_payroll, 1) OVER (ORDER BY gdp.payroll_year)) > 5
			AND	(lead(pri.perc_price_diff, 1) OVER (ORDER BY gdp.payroll_year)) > 5
		THEN 'influence in the following year'
		ELSE "can't influence"
	END GDP_impact_following_year	
FROM v_andrea_zemanova_perc_diff_GDP AS gdp
JOIN v_andrea_zemanova_avg_payroll_trend AS pay  
	ON pay.payroll_year = gdp.payroll_year 
JOIN v_andrea_zemanova_avg_price_trend AS pri 
	ON pri.payroll_year = gdp.payroll_year 
ORDER BY gdp.payroll_year 
;


-- z vysledku dotazu vyplyva, ze HDP muze ovlivnit ceny potravin a take mzdy v roce 2007, 
-- kdy procentualni rozdil HDP cinil 5.3% (stanovila jsem si, ze jako smerodatnou hodnotu budu brat HDP > 5%). Take mohl ovlivnit ceny potravin a mzdy v nasledujicim roce 2008.
-- GDP mohl ovlivnit ceny potravin a mzdy take v roce 2017




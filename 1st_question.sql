/*		Andrea Zemanová
		Discord: Andrea Z. ficaria1	
*/

SELECT * 
FROM t_andrea_zemanova_project_SQL_primary_final tazpspf 
;


ALTER TABLE t_andrea_zemanova_project_SQL_primary_final 
DROP COLUMN period
;


SELECT *
FROM t_andrea_zemanova_project_SQL_primary_final tazpspf 
GROUP BY payroll_year, industry 
ORDER BY  industry_branch_code, payroll_year
;

-- vytvoreni rozdilu mezd behem roku ve vsech odvetvich:
SELECT 
	industry,
	industry_branch_code,
	avg_value AS current_payroll,
	lag(payroll_year, 1) OVER (PARTITION BY industry ORDER BY payroll_year) AS last_year,
	payroll_year AS current_year,
	CASE 
		WHEN avg_value > LAG(avg_value, 1) OVER (PARTITION BY industry ORDER BY payroll_year) THEN 'increasing'
		WHEN avg_value < LAG(avg_value, 1) OVER (PARTITION BY industry ORDER BY payroll_year) THEN 'decreasing'
		ELSE 'no change'
	END AS 'payroll_trend'	
FROM t_andrea_zemanova_project_SQL_primary_final tazpspf 
GROUP BY payroll_year, industry 
ORDER BY industry_branch_code, payroll_year
;
-- no change = pocatecni rok
-- increasing = behem roku mzdy vzrostly
-- decreasing = behem roku mzdy klesly


-- vytvoreni pohledu:
CREATE VIEW v_andrea_zemanova_industry_payroll_trend AS 
SELECT 
	industry,
	industry_branch_code,
	avg_value AS current_payroll,
	lag(payroll_year, 1) OVER (PARTITION BY industry ORDER BY payroll_year) AS last_year,
	payroll_year AS current_year,
	CASE 
		WHEN avg_value > LAG(avg_value, 1) OVER (PARTITION BY industry ORDER BY payroll_year) THEN 'increasing'
		WHEN avg_value < LAG(avg_value, 1) OVER (PARTITION BY industry ORDER BY payroll_year) THEN 'decreasing'
		ELSE 'no change'
	END AS 'payroll_trend'	
FROM t_andrea_zemanova_project_SQL_primary_final tazpspf 
GROUP BY payroll_year, industry 
ORDER BY industry_branch_code, payroll_year
;


SELECT * 
FROM v_andrea_zemanova_industry_payroll_trend vazipt 
;

SELECT DISTINCT industry
FROM v_andrea_zemanova_industry_payroll_trend vazipt 
;
-- 19 odvetvi celkem


-- 1. otazka: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- vypis odvetvi, kde mzdy mezirocne klesly v danych letech:
SELECT *
FROM v_andrea_zemanova_industry_payroll_trend vazipt 
WHERE current_year BETWEEN 2006 AND 2018 AND payroll_trend = 'decreasing'
GROUP BY industry, payroll_trend
ORDER BY industry_branch_code 
;
-- celkem 16 odvetvi, ve kterych mzdy klesly v prubehu let


-- vypis tech odvetvi, kde mzdy rostou behem sledovanych let:
SELECT DISTINCT 
	industry,
	industry_branch_code,
	payroll_trend 
FROM v_andrea_zemanova_industry_payroll_trend AS trend
WHERE payroll_trend != 'no change' AND trend.industry_branch_code NOT IN (
	SELECT DISTINCT industry_branch_code 
	FROM (
		SELECT industry, industry_branch_code, payroll_trend
		FROM v_andrea_zemanova_industry_payroll_trend vazipt 
		WHERE payroll_trend = 'decreasing'
	) AS sub
	ORDER BY industry_branch_code
);


CREATE VIEW v_andrea_zemanova_1st_question AS
SELECT DISTINCT 
	industry,
	industry_branch_code,
	payroll_trend 
FROM v_andrea_zemanova_industry_payroll_trend AS trend
WHERE payroll_trend != 'no change' AND trend.industry_branch_code NOT IN (
	SELECT DISTINCT industry_branch_code 
	FROM (
		SELECT industry, industry_branch_code, payroll_trend
		FROM v_andrea_zemanova_industry_payroll_trend vazipt 
		WHERE payroll_trend = 'decreasing'
	) AS sub
	ORDER BY industry_branch_code
);


CREATE OR REPLACE VIEW v_andrea_zemanova_1st_question_perc_diff AS
SELECT
	industry,
	industry_branch_code,
	current_year,
	current_payroll,
	last_year,
	lag(current_payroll, 1) OVER (PARTITION BY industry_branch_code ORDER BY current_year) AS last_payroll,
	round(((current_payroll - lag(current_payroll, 1) OVER (PARTITION BY industry_branch_code ORDER BY current_year)) / lag(current_payroll, 1) 
		OVER (PARTITION BY industry_branch_code ORDER BY current_year)) * 100, 1) AS perc_diff_payroll,
	CASE 
		WHEN current_payroll > LAG(current_payroll, 1) OVER (PARTITION BY industry_branch_code ORDER BY current_year) THEN 'increasing'
		WHEN current_payroll < LAG(current_payroll, 1) OVER (PARTITION BY industry_branch_code ORDER BY current_year) THEN 'decreasing'
		ELSE 'no change'
	END AS 'payroll_trend'
FROM v_andrea_zemanova_industry_payroll_trend vazipt 
ORDER BY industry_branch_code, current_year 
;


SELECT *
FROM v_andrea_zemanova_1st_question_perc_diff vazsqpd 
WHERE perc_diff_payroll IS NOT NULL 
ORDER BY perc_diff_payroll 
;
-- největší propad ve mzdách zaznamenalo odvětví Peněžnictví a pojišťovnictví, a to v roce 2013, kdy procentuální meziroční rozdíl činil 8,8%
-- naopak největší nárůst zaznamenala dvě odvětví, 
-- a to Těžba a dobývání a Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu, kdy meziroční procentuální nárůst činil 13,8%






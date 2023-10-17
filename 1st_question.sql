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





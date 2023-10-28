-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
SELECT 
	payroll_year,
	lag(avg_payroll_each_year) OVER (ORDER BY payroll_year) AS previous_avg_payroll,
	avg_payroll_each_year,
	avg_payroll_each_year - lag(avg_payroll_each_year) OVER (ORDER BY payroll_year) AS payroll_diff,
	round(((avg_payroll_each_year - lag(avg_payroll_each_year) OVER (ORDER BY payroll_year)) / lag(avg_payroll_each_year) 
		OVER (ORDER BY payroll_year) * 100),1) AS perc_diff_payroll,
	CASE 
		WHEN round(((avg_payroll_each_year - lag(avg_payroll_each_year) OVER (ORDER BY payroll_year)) / lag(avg_payroll_each_year) 
			OVER (ORDER BY payroll_year) * 100),1) > 0 THEN 'payroll_increased'
		WHEN round(((avg_payroll_each_year - lag(avg_payroll_each_year) OVER (ORDER BY payroll_year)) / lag(avg_payroll_each_year) 
			OVER (ORDER BY payroll_year) * 100),1) < 0 THEN 'payroll_decreased'
		ELSE 'no_change'
	END AS payroll_trend
FROM (
	SELECT 
		payroll_year,
		industry,
		avg_value AS payroll_CZK,
		round(avg(avg_value) OVER (PARTITION BY payroll_year ORDER BY payroll_year),0) AS avg_payroll_each_year
	FROM t_andrea_zemanova_project_SQL_primary_final tazpspf
	ORDER BY payroll_year, industry
) AS payroll
GROUP BY payroll_year
;
-- prumer mezd za jednotlive roky 2006-2018 a procentualni mezirocni rozdil


CREATE OR REPLACE VIEW v_andrea_zemanova_avg_payroll_trend AS
SELECT 
	payroll_year,
	lag(avg_payroll_each_year) OVER (ORDER BY payroll_year) AS previous_avg_payroll,
	avg_payroll_each_year,
	avg_payroll_each_year - lag(avg_payroll_each_year) OVER (ORDER BY payroll_year) AS payroll_diff,
	round(((avg_payroll_each_year - lag(avg_payroll_each_year) OVER (ORDER BY payroll_year)) / lag(avg_payroll_each_year) 
		OVER (ORDER BY payroll_year) * 100),1) AS perc_diff_payroll,
	CASE 
		WHEN round(((avg_payroll_each_year - lag(avg_payroll_each_year) OVER (ORDER BY payroll_year)) / lag(avg_payroll_each_year) 
			OVER (ORDER BY payroll_year) * 100),1) > 0 THEN 'payroll_increased'
		WHEN round(((avg_payroll_each_year - lag(avg_payroll_each_year) OVER (ORDER BY payroll_year)) / lag(avg_payroll_each_year) 
			OVER (ORDER BY payroll_year) * 100),1) < 0 THEN 'payroll_decreased'
		ELSE 'no_change'
	END AS payroll_trend
FROM (
	SELECT 
		payroll_year,
		industry,
		avg_value AS payroll_CZK,
		round(avg(avg_value) OVER (PARTITION BY payroll_year ORDER BY payroll_year),0) AS avg_payroll_each_year
	FROM t_andrea_zemanova_project_SQL_primary_final tazpspf
	ORDER BY payroll_year, industry
) AS payroll
GROUP BY payroll_year
;
-- vytvoreni pohledu


SELECT *
FROM t_andrea_zemanova_project_SQL_primary_final tazpspf 
;



-- procentualni rozdil narustu vsech potravin za jednotliva obdobi:
SELECT 
	payroll_year,
	lag(round(avg(avg_food_year),2)) OVER (ORDER BY payroll_year) AS previous_year_price,
	round(avg(avg_food_year),2) AS year_avg_food_price,
	round(avg(avg_food_year),2) - lag(round(avg(avg_food_year),2)) OVER (ORDER BY payroll_year) AS price_diff,
	round(((round(avg(avg_food_year),2) - lag(round(avg(avg_food_year),2)) OVER (ORDER BY payroll_year)) / lag(round(avg(avg_food_year),2)) 
		OVER (ORDER BY payroll_year) * 100),2) AS perc_price_diff
FROM (
	SELECT 
		payroll_year,
		food_code,
		food, 
		price_value,
		price_unit, 
		avg_food_year 
	FROM t_andrea_zemanova_project_SQL_primary_final tazpspf 
	GROUP BY payroll_year, food_code, food, avg_food_year 
	ORDER BY payroll_year, food 
) AS pay                                      
GROUP BY payroll_year
ORDER BY payroll_year
;

-- vytvoreni pohledu:
CREATE OR REPLACE VIEW v_andrea_zemanova_avg_price_trend AS
SELECT 
	payroll_year,
	lag(round(avg(avg_food_year),2)) OVER (ORDER BY payroll_year) AS previous_year_price,
	round(avg(avg_food_year),2) AS year_avg_food_price,
	round(avg(avg_food_year),2) - lag(round(avg(avg_food_year),2)) OVER (ORDER BY payroll_year) AS price_diff,
	round(((round(avg(avg_food_year),2) - lag(round(avg(avg_food_year),2)) OVER (ORDER BY payroll_year)) / lag(round(avg(avg_food_year),2)) 
		OVER (ORDER BY payroll_year) * 100),2) AS perc_price_diff
FROM (
	SELECT 
		payroll_year,
		food_code,
		food, 
		price_value,
		price_unit, 
		avg_food_year 
	FROM t_andrea_zemanova_project_SQL_primary_final tazpspf 
	GROUP BY payroll_year, food_code, food, avg_food_year 
	ORDER BY payroll_year, food 
) AS pay
GROUP BY payroll_year
ORDER BY payroll_year
;


-- spojeni pohledu procentualnich narustu cen potravin a mezd pro porovnani, zda ceny potravin rostly v nekterem roce rychleji nez mzdy:
SELECT 
	pay.payroll_year,
	pay.perc_diff_payroll,
	pri.perc_price_diff,
	pri.perc_price_diff - pay.perc_diff_payroll AS perc_diff,
	CASE 
		WHEN pri.perc_price_diff - pay.perc_diff_payroll > 10 THEN 'food price increase more then 10%'
		WHEN pri.perc_price_diff - pay.perc_diff_payroll < 10 THEN 'payroll increase'
		ELSE 'no change'
	END AS 'payroll_price_trend'
FROM v_andrea_zemanova_avg_payroll_trend AS pay
JOIN v_andrea_zemanova_avg_price_trend AS pri
	ON pri.payroll_year = pay.payroll_year 
;
-- odpoved na 4. otazku: zadny takovy rok neexistuje. Mezirocne vice rostly mzdy nez ceny potravin


-- vytvoreni pohledu:
CREATE OR REPLACE VIEW v_andrea_zemanova_4th_question AS 
SELECT 
	pay.payroll_year,
	pay.perc_diff_payroll,
	pri.perc_price_diff,
	pri.perc_price_diff - pay.perc_diff_payroll AS perc_diff,
	CASE 
		WHEN pri.perc_price_diff - pay.perc_diff_payroll > 10 THEN 'food price increase more then 10%'
		WHEN pri.perc_price_diff - pay.perc_diff_payroll < 10 THEN 'payroll increase'
		ELSE 'no change'
	END AS 'payroll_price_trend'
FROM v_andrea_zemanova_avg_payroll_trend AS pay
JOIN v_andrea_zemanova_avg_price_trend AS pri
	ON pri.payroll_year = pay.payroll_year 
;


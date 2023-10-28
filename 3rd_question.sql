/* otazka 3:
   Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
*/

SELECT *
FROM t_andrea_zemanova_project_SQL_primary_final tazpspf 
ORDER BY food, payroll_year 
;



SELECT 
	food_code,
	food,
	round(avg(`annual_difference_%`),2) AS avg_percentage_diff
FROM (
	SELECT 
		payroll_year,
		food_code,
		food,
		avg_food_year AS price_payroll_year,
		lag(avg_food_year) OVER(PARTITION BY food ORDER BY food, payroll_year) AS price_last_year,
		avg_food_year - lag(avg_food_year) OVER(PARTITION BY food ORDER BY food, payroll_year) AS difference_price,
		round(((avg_food_year - lag(avg_food_year) OVER(PARTITION BY food ORDER BY food, payroll_year)) / lag(avg_food_year) 
			OVER(PARTITION BY food ORDER BY food, payroll_year)) * 100, 1) AS 'annual_difference_%'
	FROM (
		SELECT 
			payroll_year,
			food_code, 
			food,
			avg_food_year
		FROM t_andrea_zemanova_project_SQL_primary_final tazpspf 
		GROUP BY payroll_year, food_code, food, avg_food_year 
		ORDER BY food, payroll_year 
	) AS difference
	ORDER BY food, payroll_year
) AS avg_percentage_diff
GROUP BY food_code, food
HAVING round(avg(`annual_difference_%`),0) IS NOT NULL 
ORDER BY avg_percentage_diff
;
	
-- Cukr krystalový a Rajská jablka červená kulatá ve sledovanem obdobi zlevnily
-- nejpomaleji zdrazily banany - prumerne o 0.81 % behem sledovaneho obdobi
	

/* otazka 2:
   Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední 
   srovnatelné období v dostupných datech cen a mezd?
*/

SELECT 
	payroll_year,
	food, 
	avg_food_year AS avg_food_price_per_year, 
	unit AS CZK,
	round(avg(avg_value), 2) AS avg_total_payroll_per_year,
	round((round(avg(avg_value), 2) / avg_food_year), 0) AS total_food_per_year,
	price_unit AS amount_unit
FROM t_andrea_zemanova_project_SQL_primary_final tazpspf
WHERE food IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované') AND payroll_year IN (2006, 2018)
GROUP BY payroll_year, food, avg_food_year
ORDER BY food, payroll_year 
;
-- za rok 2006 si lide mohli koupit prumerne 1313 kg chleba, za rok 2018 1365 kg chleba
-- za rok 2006 si lide mohli koupit prumerne 1466 l mleka, za rok 2018 1670 l mleka 


SELECT 
	payroll_year,
	food, 
	avg_food_year AS avg_food_price_per_year, 
	unit AS CZK,
	round(sum(avg_value), 2) AS total_payroll_per_year,
	round((round(sum(avg_value), 2) / avg_food_year), 0) AS total_food_per_year,
	price_unit AS amount_unit
FROM t_andrea_zemanova_project_SQL_primary_final tazpspf
WHERE food IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované') AND payroll_year IN (2006, 2018)
GROUP BY payroll_year, food, avg_food_year
ORDER BY food, payroll_year 
;
-- za rok 2006 si lide mohli koupit celkem 24947 kg chleba, za rok 2018 25938 kg chleba
-- za rok 2006 si lide mohli koupit celkem 27849 l mleka, za rok 2018 31723 l mleka 

-- conclusion: ceny chleba a mleka rostou pomaleji nez platy za srovnatelna obdobi
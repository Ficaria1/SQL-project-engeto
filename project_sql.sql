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

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


-- 6880 radku celkem:

SELECT count(*)
FROM v_andrea_zemanova_payroll_complete vazpc
;


SELECT 
	payroll_year,
	industry,
	industry_branch_code,
	round(avg(value)) AS avg_value,
	unit
FROM v_andrea_zemanova_payroll_complete vazpc 
WHERE unit = 'Kč' AND calculation = 'přepočtený'
GROUP BY payroll_year,
	industry,
	industry_branch_code,
	unit
ORDER BY payroll_year, industry_branch_code
;







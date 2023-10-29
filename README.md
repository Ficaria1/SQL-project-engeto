# SQL-project-ENGETO

## Analýza dat mezd a cen potravin v České republice pomocí SQL

### Projekt:
Cílem projektu je vytvořit primární a sekundární finální tabulku pomocí SQL strukturovaného dotazovacího jazyka. Na základě těchto tabulek je pak zapotřebí sestavit dodatečné sady SQL skriptů k zodpovězení 5 výzkumných otázek. <br>

#### Výzkumné otázky: 
- ***1. otázka:***
Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? <br>

- ***2. otázka:***
Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? <br>

- ***3. otázka:***
Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

- ***4. otázka:***
Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

- ***5. otázka:***
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?


#### Datové sady, které je možné použít pro získání vhodného datového podkladu:
zdroj dat: Portál otevřených dat ČR <br>

<img src="https://github.com/Ficaria1/SQL-project-engeto/assets/144990489/5e65d415-1355-4cf0-aa4d-687c8eedbb59" alt="primární" width= 70> **Primární tabulky:**

- ***czechia_payroll*** – informace o mzdách v různých odvětvích za několikaleté období
- ***czechia_payroll_calculation*** – číselník kalkulací v tabulce mezd

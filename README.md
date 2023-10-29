# SQL-project-ENGETO

## Analýza dat mezd a cen potravin v České republice pomocí SQL

### Projekt:
Cílem projektu je vytvořit primární finální tabulku (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) a sekundární finální tabulku (pro dodatečná data o dalších evropských státech s HDP, GINI koeficientem a populací) pomocí SQL strukturovaného dotazovacího jazyka. Na základě těchto tabulek je pak zapotřebí sestavit dodatečné sady SQL skriptů k zodpovězení 5 výzkumných otázek. <br>

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
- ***czechia_payroll_industry_branch*** - číselník odvětví v tabulce mezd
- ***czechia_payroll_unit*** - číselník jednotek hodnot v tabulce mezd
- ***czechia_payroll_value_type*** - číselník typů hodnot v tabulce mezd
- ***czechia_price*** - informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR
- ***czechia_price_category*** - číselník kategorií potravin, které se vyskytují v našem přehledu

<img src="https://github.com/Ficaria1/SQL-project-engeto/assets/144990489/5b3657ae-ade9-4888-8eef-499688a04a17" alt="sekundární" width= 70> **Sekundární tabulky:**

Číselníky sdílených informací o ČR:
- ***czechia_region*** - číselník krajů České republiky dle normy CZ-NUTS 2
- ***czechia_district*** - číselník okresů České republiky dle normy LAU

Dodatečné tabulky:
- ***countries*** - všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace
- ***economies*** - HDP, GINI, daňová zátěž, atd. pro daný stát a rok

#### Postup zpracování projektu:

* vypracování primární finální tabulky: 






















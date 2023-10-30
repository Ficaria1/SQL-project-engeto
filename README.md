# SQL-projekt_1-ENGETO

## Analýza dat mezd a cen potravin v České republice pomocí SQL

### Projekt:
Cílem projektu je vytvořit primární finální tabulku (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) a sekundární finální tabulku (pro dodatečná data o dalších evropských státech s HDP, GINI koeficientem a populací) pomocí SQL strukturovaného dotazovacího jazyka. Na základě těchto tabulek je pak zapotřebí sestavit dodatečné sady SQL skriptů k zodpovězení 5 výzkumných otázek. <br>

#### Výzkumné otázky: 
 ***1. otázka:***
Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? <br>

 ***2. otázka:***
Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? <br>

 ***3. otázka:***
Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

 ***4. otázka:***
Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

 ***5. otázka:***
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

  * prvním krokem bylo vytvoření primární tabulky `t_andrea_zemanova_project_SQL_primary_final`, dále pak vytvoření sekundární tabulky `t_andrea_zemanova_project_SQL_secondary_final`
  * následně byly vytvořeny dodatečné sady SQL skriptů, které vedly k zodpovězení pěti již zmíněných výzkumných otázek
  * podrobnější popis jednotlivých sad SQL dotazů je uveden v komentářích u příslušných skriptů

  <br>
  
**Vypracování primární finální tabulky** `t_andrea_zemanova_project_SQL_primary_final`: 
- nejprve jsem pomocí příkazu LEFT JOIN spojila všechny přidružené tabulky s tabulkou `czechia_payroll`:
  https://github.com/Ficaria1/SQL-project-engeto/blob/c03d8ad1bf99bb491e71e2270a7c8731acef92f2/final_table_1.sql#L1-L19
  
- vybírám data 'Průměrná hrubá mzda na zaměstnance' pro sloupec `type`, 'přepočtený' pro sloupec `calculation` (zohledňuji přepočtené hodnoty vzhledem k typu úvazku)
 
- odstraním NULL hodnoty pro sloupec `industry`
 
- vypočítám průměrné mzdy pro dané odvětví za rok:
  https://github.com/Ficaria1/SQL-project-engeto/blob/c03d8ad1bf99bb491e71e2270a7c8731acef92f2/final_table_1.sql#L171-L183
 
- sjednotím všechny přidružené tabulky k tabulce `czechia_price`:
  https://github.com/Ficaria1/SQL-project-engeto/blob/c03d8ad1bf99bb491e71e2270a7c8731acef92f2/final_table_1.sql#L214-L230
 
- vybírám hodnoty pro sloupec `region_code` IS NULL - jedná se o průměrné ceny potravin v daném roce (toto ověření jsem dokázala výpočtem viz konkrétní SQL sada skriptů v souboru final_table_1.sql):
   https://github.com/Ficaria1/SQL-project-engeto/blob/c03d8ad1bf99bb491e71e2270a7c8731acef92f2/final_table_1.sql#L298-L321
  
- finální skript vyčištěný od NULL hodnot (potřebuji jen data pro společné roky) pro vytvoření primární tabulky `t_andrea_zemanova_project_SQL_primary_final`: <br>
   https://github.com/Ficaria1/SQL-project-engeto/blob/c03d8ad1bf99bb491e71e2270a7c8731acef92f2/final_table_1.sql#L526-L532

  <br>
  
**Vypracování sekundární finální tabulky** `t_andrea_zemanova_project_SQL_secondary_final`: 
- spojím tabulky `economies` a `countries` pomocí společného sloupečku `country`, vyberu jen státy Evropy a roky 2006 až 2018
  
- v tabulce mám také požadované hodnoty HDP, GINI koeficientu a populace:
  https://github.com/Ficaria1/SQL-project-engeto/blob/2df78c36664334d72efc9bd3a00c286e1fe8a861/final_table_2.sql#L91-L111

  <br>

**Otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**
- pomocí následujícího dotazu zjistím rozdíl mezd všech odvětví v jednotlivých letech:
  https://github.com/Ficaria1/SQL-project-engeto/blob/1165e9f795d3899a81680027eeed533b21147463/1st_question.sql#L39-L55
  
- z vytvořeného pohledu vypíšu ta odvětví, kde mzdy zaznamenaly pokles mezi lety 2006 až 2018:
  https://github.com/Ficaria1/SQL-project-engeto/blob/1165e9f795d3899a81680027eeed533b21147463/1st_question.sql#L69-L74
  
- výsledkem je, že mzdy zaznamenaly pokles alespoň jednou za dané roky v 16 odvětvích
  
- zjišťuji, ve kterých odvětvích mzdy rostou kontinuálně během let 2006 až 2018:
  https://github.com/Ficaria1/SQL-project-engeto/blob/1165e9f795d3899a81680027eeed533b21147463/1st_question.sql#L95-L109
  
- vypsání procentuálního rozdílu mezd v rámci jednotlivých let:
  https://github.com/Ficaria1/SQL-project-engeto/blob/1165e9f795d3899a81680027eeed533b21147463/1st_question.sql#L112-L129
  
- seřazení daných hodnot v pohledu `v_andrea_zemanova_1st_question_perc_diff` vzestupně podle sloupce `perc_diff_payroll`:
  https://github.com/Ficaria1/SQL-project-engeto/blob/1165e9f795d3899a81680027eeed533b21147463/1st_question.sql#L132-L136
  
- **Závěr:**
  * pozitivní kontinuální nárůst mezd je pozorován u tří odvětví, v těchto odvětvích nebyl zaznamenán žádný pokles mezd v letech 2006 až 2018:
    - 'Zpracovatelský průmysl'
    - 'Zdravotní a sociální péče'
    - 'Ostatní činnosti'
  * největší nárůst zaznamenala dvě odvětví, a to 'Těžba a dobývání' a 'Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu', kdy meziroční procentuální nárůst činil 13,8%
    <br>
  * naopak v 16 odvětvích je patrný pokles mezd alespoň jednou v rámci sledovaných let
  * největší propad ve mzdách zaznamenalo odvětví 'Peněžnictví a pojišťovnictví', a to v roce 2013, kdy procentuální meziroční rozdíl činil 8,8%

    <br>

**Otázka č. 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**
- vypočítám si průměrné hrubé mzdy v letech 2006 a 2018 ze všech odvětví
- následně tyto průměrné hrubé mzdy vydělím průměrnými cenami daných potravin ('Chléb konzumní kmínový' a 'Mléko polotučné pasterované'):
   https://github.com/Ficaria1/SQL-project-engeto/blob/7753c3e49b4c9c332ab1cbb4b656f03c646d1447/2nd_question.sql#L6-L18

  
- **Závěr:**
  * průměrná hrubá mzda v roce 2006 činila 21 165 Kč - za tuto mzdu bylo možné pořídit např. 1313 kg zboží 'Chléb konzumní kmínový', jehož průměrná cena činila 16.12 Kč, nebo 1466 l zboží 'Mléko polotučné pasterované', jehož průměrná cena v roce 2006 byla 14,44 Kč
  * průměrná hrubá mzda v roce 2018 činila 33 092 Kč - a za tutuo mzdu bylo možné pořídit např. 1365 kg zboží 'Chléb konzumní kmínový', jehož průměrná cena činila 24,24 Kč, nebo 1670 l zboží 'Mléko polotučné pasterované', jehož průměrná cena v roce 2018 činila 19,82 Kč
    
























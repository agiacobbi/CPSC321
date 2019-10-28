/*
Alex Giacobbi
CPSC 321
HW6
Technical work -- querying the country/province/city info database
*/

-- drop tables before each run to ensure fresh start
DROP TABLE Border;
DROP TABLE City;
DROP TABLE Province;
DROP TABLE Country;

-- 1. Create all tables and populate with entries
CREATE TABLE Country( 
    country_code VARCHAR(50) NOT NULL,
    country_name VARCHAR(256),
    gdp INT,
    inflation DOUBLE,
    
    PRIMARY KEY (country_code));

CREATE TABLE Province( 
    province_name VARCHAR(256) NOT NULL, 
    country_code VARCHAR(50) NOT NULL, 
    area INT,  
    
    PRIMARY KEY (province_name, country_code), 
    FOREIGN KEY (country_code) REFERENCES Country(country_code));

CREATE TABLE City(
    city_name VARCHAR(256) NOT NULL,
    province_name VARCHAR(256) NOT NULL,
    country_code VARCHAR(50) NOT NULL,
    population INT,
    
    PRIMARY KEY (city_name, province_name, country_code),
    FOREIGN KEY (province_name, country_code) REFERENCES Province(province_name, country_code));

CREATE TABLE Border( 
    country_code_1 VARCHAR(50) NOT NULL, 
    country_code_2 VARCHAR(50) NOT NULL,
    border_length INT,
    
    PRIMARY KEY (country_code_1, country_code_2),
    FOREIGN KEY (country_code_1) REFERENCES Country(country_code),
    FOREIGN KEY (country_code_2) REFERENCES Country(country_code));


INSERT INTO Country VALUES 
    ("AAA", "Country A", 83928, 2.4), 
    ("BBB", "Country B", 39274, 4.3), 
    ("CCC", "Country C", 94832, 3.6), 
    ("DDD", "Country A", 37754, 2.3),
    ("EEE", "Country E", 99932, 1.0);

INSERT INTO Province VALUES 
    ("Province A", "AAA", 28294), 
    ("Province Cat", "AAA", 9283), 
    ("Province 32", "BBB", 29433), 
    ("Province 28", "DDD", 290398), 
    ("Province Cat", "CCC", 928369),
    ("Tiny Province", "EEE", 2938);

INSERT INTO City VALUES 
    ("Squaretown", "Province A", "AAA", 2098433), 
    ("Circleland", "Province A", "AAA", 8230),
    ("Triangle City", "Province A", "AAA", 229382),
    ("Springfield", "Province Cat", "CCC", 209883), 
    ("Springfield", "Province Cat", "AAA", 245678), 
    ("Westland", "Province 28", "DDD", 987653), 
    ("Point Mountain", "Province Cat", "CCC", 87);

INSERT INTO Border VALUES
    ("AAA", "BBB", 9872),
    ("AAA", "CCC", 223),
    ("BBB", "DDD", 2243),
    ("EEE", "AAA", 22),
    ("EEE", "DDD", 189928);

-- 2. Select all countries containing a province with small area but low inflation and high 
--    GDP
SET @gdp = 50000;
SET @inflation = 3;
SET @area = 30000;

SELECT DISTINCT c.country_name, c.country_code, c.gdp, c.inflation 
FROM Country c, Province p 
WHERE c.country_code = p.country_code 
AND c.gdp > @gdp 
AND c.inflation < @inflation 
AND p.area < @area;

-- 3. Repeat 2 with INNER JOIN
SELECT DISTINCT c.country_name, c.country_code, c.gdp, c.inflation 
FROM Country c
INNER JOIN Province p on c.country_code = p.country_code
WHERE c.gdp > @gdp 
AND c.inflation < @inflation 
AND p.area < @area;

-- 4. Select all province names and areas that have at least one city with a population 
--    greater than 1000
SET @population = 1000;

SELECT DISTINCT p.country_code, cn.country_name, p.province_name, c.city_name, c.population, p.area 
FROM Province p, City c, Country cn
WHERE p.province_name = c.province_name
AND p.country_code = c.country_code
AND p.country_code = cn.country_code
AND c.country_code = cn.country_code
AND c.population > @population;

-- 5. Repeat 4 with INNER JOIN
SELECT DISTINCT p.country_code, cn.country_name, p.province_name, c.city_name, c.population, p.area 
FROM Province p
INNER JOIN City c ON p.province_name = c.province_name AND p.country_code = c.country_code
INNER JOIN Country cn ON p.country_code = cn.country_code AND c.country_code = cn.country_code
AND c.population > @population;

-- 6. Find the total area of all provinces that are within countries with a GDP in a certain range
SET @gdpLow = 50000;
SET @gdpHigh = 95000;

SELECT SUM(p.area) FROM Country c
INNER JOIN Province p ON c.country_code = p.country_code
WHERE c.gdp > @gdpLow
AND c.gdp < @gdpHigh;

-- 7. Find the min, max, and average of GDP and inflation of all the countries
SELECT MIN(gdp), MAX(gdp), AVG(gdp), MIN(inflation), MAX(inflation), AVG(inflation)
FROM Country;

-- 8. Find the number of cities and the average population withing a specific country
SET @country = "AAA";

SELECT COUNT(city_name), AVG(population)
FROM City
WHERE country_code = @country;

-- 9. Find the average population of cities that are within a specific province and 
--    country as a given city without including the city's population in the average
SET @city = "Squaretown";
SET @province = "Province A";

SELECT AVG(population), @city
FROM City
WHERE province_name = @province
AND country_code = @country
AND city_name != @city;

-- 11. Find the number of countries that a specific country borders and its average
--     border length
SELECT COUNT(*), AVG(border_length)
FROM Border
WHERE country_code_1 = @country
OR country_code_2 = @country;

-- 12. Use UNION to find unique names of countries with a lower GDP and a higher inflation
--     than the country it borders
SELECT DISTINCT c1.country_code, c1.country_name, c1.gdp, c1.inflation
FROM Country c1
INNER JOIN Border b ON b.country_code_1 = c1.country_code
INNER JOIN Country c2 ON b.country_code_2 = c2.country_code
WHERE c1.gdp < c2.gdp
AND c1.inflation > c2.inflation
UNION
SELECT DISTINCT c2.country_code, c2.country_name, c2.gdp, c2.inflation
FROM Country c1
INNER JOIN Border b ON b.country_code_1 = c1.country_code
INNER JOIN Country c2 ON b.country_code_2 = c2.country_code
WHERE c1.gdp > c2.gdp
AND c1.inflation < c2.inflation;
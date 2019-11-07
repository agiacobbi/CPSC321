/*
Alex Giacobbi
CPSC 321
HW7
Technical work -- querying the country/province/city info database
*/

-- INSERT INTO City VALUES
--     ("Polygonopolis", "Province A", "AAA", 5848298),
--     ("Lakeriver", "Province Cat", "CCC", 34567898);


--  1. Write an SQL query that finds the GDP, inflation, and total population of each country.
SELECT co.country_code, co.country_name, co.gdp, co.inflation, SUM(ci.population)
FROM City ci
RIGHT JOIN Country co ON ci.country_code = co.country_code
GROUP BY co.country_code;


--  2. Write an SQL query to find the name, area, and total population of provinces with a population
--     over 5,000,000 people
SELECT p.country_code, p.province_name, p.area, SUM(c.population)
FROM Province p
RIGHT JOIN City c ON p.country_code = c.country_code
AND p.province_name = c.province_name
GROUP BY p.province_name
HAVING SUM(c.population) > 5000000;


--  3. Write an SQL query that orders countries by their size in terms of the number of cities they
--     have. Return the country code, name, and size such that countries are returned in order from the
--     most to the fewest number of cities
SELECT co.country_code, co.country_name, COUNT(ci.city_name)
FROM City ci
RIGHT JOIN Country co ON ci.country_code = co.country_code
GROUP BY co.country_code
ORDER BY COUNT(ci.city_name) DESC;


--  4. Write an SQL query that orders countries by their total area. Let a country’s area be the sum
--     of the areas of its provinces. Return the country code, name, and total area such that countries
--     are returned in order from the largest to smallest area.
SELECT c.country_code, c.country_name, SUM(p.area)
FROM Province p
RIGHT JOIN Country c ON p.country_code = c.country_code
GROUP BY c.country_code
ORDER BY SUM(p.area) DESC;


--  5. Write an SQL query that finds countries containing one or more provinces with at least a given
--     number of cities.  Return the name of each matching country.
SET @numCities = 2;

SELECT co.country_name
FROM City ci
LEFT JOIN Country co on ci.country_code = co.country_code
GROUP BY ci.province_name, ci.country_code
HAVING (COUNT(*) >= @numCities);


--  6. Write an SQL query that orders countries by the number of cities they contain for countries
--     with an area smaller than a given area value and with a gdp larger than a given gdp value. Include
--     each country’s code, gdp value, area, and number of cities. Countries should be returned in order
--     from the fewest to the most number of cities. If two countries have the same number of cities, they
--     should be returned in order from the largest to the smallest gdp.
SET @maxArea = 300000;
SET @minGDP = 38000;

SELECT co.country_code, co.gdp, COUNT(DISTINCT ci.city_name, ci.province_name)
FROM Country co
LEFT JOIN Province pr ON co.country_code = pr.country_code
LEFT JOIN City ci ON co.country_code = ci.country_code
GROUP BY co.country_code
HAVING SUM(pr.area) < @maxArea
AND co.gdp > @minGDP
ORDER BY COUNT(ci.city_name) DESC, co.gdp ASC;

--  7. Write a view called sym_borders that “completes” the borders relation such that if a row (c1,
--     c2,len) is in borders, then both (c1,c2,len) and (c2,c1,len) is in sym_borders. In other words,
--     the sym_borders relation is the symmetric version of the borders relation.
DROP VIEW sym_borders;
CREATE VIEW sym_borders AS
    SELECT country_code_1, country_code_2, border_length
    FROM Border
    UNION
    SELECT country_code_2, country_code_1, border_length
    FROM Border;

SELECT * from sym_borders;


--  8. Rewrite query 12 from HW-6 using your view from question 8.  Note that the UNION is no
--     longer needed.  Ensure your queries return the same results.
SELECT DISTINCT c1.country_code, c1.country_name, c1.gdp, c1.inflation
FROM Country c1
INNER JOIN sym_borders b ON b.country_code_1 = c1.country_code
INNER JOIN Country c2 ON b.country_code_2 = c2.country_code
WHERE c1.gdp < c2.gdp
AND c1.inflation > c2.inflation;


--  9. Write an SQL query that finds for each country, the average GDP and inflation of each of its
--     bordering countries.  Your query should return the countries in order from lowest to highest average
--     GDP. If two countries have the same average GDP, output countries with the smallest to largest
--     average inflation.  Note you should use your sym_borders relation in your query.
SELECT c1.country_code, AVG(c2.gdp), AVG(c2.inflation)
FROM Country c1
INNER JOIN sym_borders b ON b.country_code_1 = c1.country_code
INNER JOIN Country c2 ON b.country_code_2 = c2.country_code
GROUP BY c1.country_code;


-- 10. Develop  two  different,  but  (at  least  somewhat)  interesting  prepared  statements  for  your
--     database.  Call each one with multiple arguments to ensure they work correctly.

-- gets the inflation for countries that are at least a certain area
PREPARE get_countries_size FROM
    "SELECT c.country_code, c.country_name, c.inflation
    FROM Province p
    RIGHT JOIN Country c ON p.country_code = c.country_code
    GROUP BY c.country_code
    HAVING SUM(p.area) > ?";

SET @areaLimit = 10000;
EXECUTE get_countries_size USING @areaLimit;
SET @areaLimit = 100000;
EXECUTE get_countries_size USING @areaLimit;

-- gets the first n largest cities in our database by population
PREPARE get_n_largest_cities FROM
    "SELECT country_code, province_name, city_name, population
    FROM City
    ORDER BY population DESC LIMIT ?";

SET @numCities = 3;
EXECUTE get_n_largest_cities USING @numCities;
SET @numCities = 5;
EXECUTE get_n_largest_cities USING @numCities;
---------------------------------------------------------------------------------

-- Summer Olympic Games
-- #1 Number of athletes by Sport
SELECT
sport,
COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport
ORDER BY athletes DESC
LIMIT 3;

--------------------------------------------------------------------------------

-- Athletes (x) vs Events (y) Visual by Sport
SELECT
sport,
COUNT(DISTINCT event) AS events,
COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport;

-- Explanation: This query returns a column of sports then events and then athletes so we can create a visualization from the default dataset. 

--------------------------------------------------------------------------------

-- Most Gold Medals
SELECT
a.name AS athlet_name,
SUM(gold) as gold_medals
FROM summer_games as s
join athletes as a
on s.athlete_id = a.id
GROUP BY a.name
HAVING sum(gold) > 2
ORDER BY gold_medals DESC;

--------------------------------------------------------------------------------

-- WHERE vs HAVING 
-- this would work to filter the list for events that have athletes over the age of 40.
SELECT athletes
FROM summer_games
WHERE age > 40

-- Better option
-- Subqueries select ID in the where age > 40 clause works

-- Doesnt work
-- using the HAVING filter becuase it works after aggreagtions and that filters out entire events instead of individual athletes.
  
-------------------------------------------------------------------------------

-- UNION ALL
-- The goal is to create a report from summer and winter season events to find the unique number of events. 
SELECT
  'summer' as season,
  country,
  count(distinct event) as events
FROM summer_games as s
JOIN countries as c
ON s.country_id = c.id
GROUP BY country          -- column1: season, column2: country, col3: events

UNION ALL

SELECT
  'winter' as season,
  country,
  count(distinct event) as events
FROM winter_games as w
JOIN countries as c
ON w.country_id = c.id
GROUP BY country
ORDER BY events DESC;

------------------------------------------------------------------------------

-- CASE WHEN
-- Categorize players into three segments: tall female, tall male, or other
SELECT
  name,
  CASE
  WHEN gender = 'F' AND height >= 175 THEN 'Tall Female'
  WHEN gender = 'M' AND height >= 190 THEN 'Tall Male'
  ELSE 'Other' END AS segment
  FROM athletes;

-------------------------------------------------------------

-- CASE WHEN
-- BMI buckets
SELECT
  sport,
  CASE 
  WHEN 100 * weight/height^2 <.25 THEN '<.25'
  WHEN 100 * weight/height^2 <=.30 THEN '.25-.30'
  WHEN 100 * weight/height^2 >.30 THEN '>.30'
  END AS bmi_bucket,
  COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games as s
JOIN athletes as a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;

------------------------------------------------------------------------------

-- Labeling Nulls
SELECT
  sport,
  CASE 
  WHEN 100 * weight/height^2 <.25 THEN '<.25'
  WHEN 100 * weight/height^2 <=.30 THEN '.25-.30'
  WHEN 100 * weight/height^2 >.30 THEN '>.30'
  ELSE 'no weight recorded'                    -- This covers NULL values
  END AS bmi_bucket,
  COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games as s
JOIN athletes as a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;

------------------------------------------------------------------------------

-- Subquery to filter from Seperate table
SELECT
  SUM(bronze) AS bronze_medals,
  SUM(silver) AS silver_medals,
  SUM(gold) AS gold_medals
FROM summer_games
WHERE athlete_id IN
  (SELECT id
  FROM athletes
  WHERE age <= 16);

-------------------------------------------------------------------------------

-- Top Athletes in Nobel-Prized countries
SELECT 
  event,
  CASE
  WHEN event LIKE '%Women%' THEN 'female'
  ELSE 'male' END AS gender,
  COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games                    -- Summer Olympic Games
WHERE country_id IN (                -- Filters for Nobel-Prize Countries
  SELECT
  country_id
  FROM country_stats
  WHERE nobel_prize_winners > 0)
GROUP BY event

UNION
SELECT
  event,
  CASE 
  WHEN event LIKE '%Women%' THEN 'female'
  ELSE 'male' END AS gender,
  COUNT(DISTINCT athlete_id) AS athletes
FROM winter_games                  -- Winter Olympic Games
WHERE country_id IN (
  SELECT country_id
  FROM country_stats
  WHERE nobel_prize_winners > 0)
GROUP BY event
ORDER BY athletes DESC          -- Events with the most athletes appear first
LIMIT 10;

-- Explanation: The query combines data from Summer and Winter games and filters for countries with at least one nobel prized winner however this condition can be changed for other business cases with different requirements. The Insight from this query that the top 4 events with the most unique athletes are female dominated ranging from 56-50 women in the swimming women's 4x100 metres Medly Relay at 56. The first male dominated event is the men's 4x200 metres freestyle relay also for swimming. 
------------------------------------------------------------------------------

-- Identify Data Types
-- The goal is to help plan your query for potential issues by identifying the issues with the current state of data types for each column.
SELECT 
  column_name,
  data_type
FROM information_schema.columms
WHERE table_name = 'country_stats';
  
-- Explanation: A group of tables or schema provides information about the database itself. This is the non-default schema. The first column is the name of each column in the 'country_stats' table and then the data type column.

---------------------------------------------------------------------------------

-- Covert to Float
-- The first query will produce an error message
SELECT
  AVG(population_in_millions) AS avg_population
FROM country_stats;

-- this second query will work
SELECT 
  AVG(CAST(population_in_millions AS float)) AS avg_population
FROM country_stats;

-- Explanation: The first query attempts to find the average population from a table 'country_stats'. The population column was originally in 'character varying' data type which is unsuitable for an aggregation function such as AVG(). The second query converts this data type to a float before the aggregation function. 

---------------------------------------------------------------------------------

-- Integer = Character Varying
SELECT
  s.country_id,
  COUNT(DISTINCT s.athlete_id) as summer_athletes
  COUNT(DISTINCT w.athelte_id) as winter_athletes
FROM summer_games as s
JOIN winter_games as w
ON s.country_id = w.country_id
GROUP BY s.country_id;

-- Explanation: The query above will not work becase the 'country_id' for the summer_games table is an integer and the 'country_id' for the winter_games is character varying data type. To fix this error we will cast the CHARVAR data type
SELECT
  s.country_id,
  COUNT(DISTINCT s.athlete_id) as summer_athletes
  COUNT(DISTINCT w.athelte_id) as winter_athletes
FROM summer_games as s
JOIN winter_games as w
ON s.country_id = CAST(w.country_id AS INT)      --- CAST( AS INT) fixed error
GROUP BY s.country_id;

--------------------------------------------------------------------------------

-- DATE_PART() & DATE_TRUNC()
SELECT
  year,
  DATE_PART('decade', CAST(year AS date)) AS decade,
  DATE_TRUNC('decade', CAST(year AS date)) AS decade_truncated,
  SUM(gdp) AS world_gdp
FROM country_stats
GROUP BY year
ORDER BY year DESC;

-- Explanation: The date_part() function extracts the decade part from the year field. The 'year' field is first cast as a date type to ensure compatibility with the date_part() function. This function turns the year 2016 into 201 and the year 2009 to the value 200 as this represents the decade each year value is in.

-- Explanation: The date_trunc() function turns the value from the year field to the start of the year of the start of the decade. For example, 2016-01-01 is truncated to the value 2010-01-01 00:00:00+01:00.

---------------------------------------------------------------------------------

-- Lowercase Strings
SELECT
  country,
  lower(country) as country_altered
FROM countries
GROUP BY country;

-- Proper-Case Strings
SELECT
  country,
  INITCAP(country) as country_altered
FROM countries
GROUP BY country;

-- Explanation: The INITCAP() function uppercases the first character of each word and lowercases the rest of the word. For values with multiple words such as 'CAN - Canada' the function returns 'Can - Canada'. Another example is 'T.TO - TRINIDAD and Tobago' is turned into 'T.To - Trinidad And Tobago'. 

---------------------------------------------------------------------------------

-- The First 3 Characters
SELECT
  country,
  LEFT(country,3) as country_altered
FROM countries
GROUP BY country;

-- Start with 7th Character
SELECT
  country,
  substring(country from 7) as country_altered
FROM countries
GROUP BY country;

-- Explanation: The values seem to have the abbreviation in the first three characters so the LEFT() function is ideal to extract the abbreviation for countries. The SUBSTRING() function would be ideal to extract the full name of the country which starts at the 7th character in the strings. 

---------------------------------------------------------------------------------

-- Replace Characters
SELECT
  region,
  replace(region, '.', ' ') AS remove_period
FROM countries
WHERE region = 'Latin Amer. & Carib'
GROUP BY region;

-- Explanation: we replace the period with a space in the string specified in the WHERE clause. Note that if we do not leave an space in between the third argument of the replace function, it will interpret this as removing a space and return the value 'Latin Amer& Carib'.
SELECT
  region,
  REPLACE(replace(region, '.', ' '),'&','and') AS remove_period
FROM countries
WHERE region = 'Latin Amer. & Carib'
GROUP BY region;

-- Explanation: By using a nested replace() function we can remove the period and replace the '&' symbol with 'and'.

--------------------------------------------------------------------------------

-- Clean Event Strings
-- Pull the number of distinct athletes by event
SELECT
  event,              -- leading white space
  COUNT(DISTINCT athlete_id) as athletes
FROM summer_games_messydata
GROUP BY event;      -- 6 rows typed for 2 events

-- Remove Leading/Trailing Spaces
SELECT
  trim(event) as event_fixed,           -- Removes Spaces
  COUNT(DISTINCT athlete_id) as athletes
FROM summer_games_messydata
GROUP BY event;

-----------------------------------------------

-- Removes '-' with ''
SELECT
    REPLACE(TRIM(event),'-','') AS event_fixed, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games_messy
GROUP BY event_fixed;

-- Explaination: The nested trim() function removes the leading and trailing whitespace and the outer replace() function removes the dash. An example of this would be '  men's- 200 metres' to 'men's 200 metres'.

---------------------------------------------------------------------------------

-- NULL values are first when ORDER BY DESC
SELECT 
	country, 
    SUM(gold) AS gold_medals
FROM winter_games AS w
JOIN countries AS c
ON w.country_id = c.id

WHERE gold IS NOT NULL    -- But can be removed with IS NOT NULL
GROUP BY country

ORDER BY gold_medals DESC;

--------------------------------------------------------------------------------

-- NULL values can be excluded in HAVING clause as well
SELECT 
  country,
  SUM(gold) as gold_medals
FROM winter_games as w
JOIN countries as c
ON w.country_id = c.id
GROUP BY country
HAVING SUM(gold) IS NOT NULL
ORDER BY gold_medals DESC;

--------------------------------------------------------------------------------

-- Total Events for Summer Olympic Games
SELECT
  athlete_id,
  count(event) as total_events,
  sum(gold) as gold_medals
FROM summer_game
GROUP BY athlete_id
ORDER BY total_events DESC, athlete_id;    -- By default ASC for athlete_id







-- List of Events
SELECT DISTINCT event
FROM winter_games;


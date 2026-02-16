-------------------------------------------------------------------------------

-- UNION ALL
-- The goal is to create a report from Summer Olympic and Winter Olympic season events, then find the unique number of events. 
SELECT
  'summer' as season,
  country,
  count(distinct event) as events
FROM summer_games as s
JOIN countries as c
ON s.country_id = c.id
GROUP BY country          

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
-- BMI buckets
-- & Labeling Nulls

SELECT
  sport,
  CASE 
  WHEN 100 * weight/height^2 <.25 THEN '<.25'
  WHEN 100 * weight/height^2 <=.30 THEN '.25-.30'
  WHEN 100 * weight/height^2 >.30 THEN '>.30'
  ELSE 'no weight recorded'                 -- This labels NULL values
  END AS bmi_bucket,
  COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games as s
JOIN athletes as a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;

------------------------------------------------------------------------------

-- Subquery to filter from young athletes
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

-- Subquery for Top Athletes in Nobel-Prized countries

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
WHERE country_id IN (			   -- Filters for Nobel-Prize Countries
  SELECT country_id
  FROM country_stats
  WHERE nobel_prize_winners > 0)
GROUP BY event
ORDER BY athletes DESC          -- Events with the most athletes appear first
LIMIT 10;

-- Explanation: The query combines data from Summer and Winter games and filters for countries with at least one nobel prized winner however this condition can be changed for other business cases with different requirements. The Insight from this query that the top 4 events with the most unique athletes are female dominated ranging from 56-50 women in the swimming women's 4x100 metres Medly Relay at 56. The first male dominated event is the men's 4x200 metres freestyle relay also for swimming. 

------------------------------------------------------------------------------

-- Total Medals by Population in Millions
-- Replace Null for SUM function
SELECT
	c.country,
	pop_in_millions,
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
JOIN country_stats AS cs
ON s.country_id = cs.country_id
GROUP BY c.country, pop_in_millions
ORDER BY medals DESC;

--------------------------------------------------------------------------------

-- Remove Leading Spaces, Convert to UpperCase, Remove '.', Only 3 Charactersr
SELECT
	left(replace(upper(trim(c.country)),'.',''),3) AS country_abreviation,
	pop_in_millions,
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
JOIN country_stats AS cs
ON s.country_id = cs.country_id AND s.year = CAST(cs.year AS date) -- Removes dup
GROUP BY c.country, pop_in_millions
ORDER BY medals_per_million DESC;

--------------------------------------------------------------------------------

-- Highest GDP value for world
SELECT
	country_id,
	year,
	gdp,
	MAX(gdp) OVER() AS global_max_gdp
	-- Max GDP for Each Country
	MAX(gdp) OVER (PARTITION BY country_id) AS country_max_gdp
	-- Assign Regional Rank to Each Athlete
	ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(gold) DESC) AS row_num
FROM country_stats
JOIN athletes AS a
ON a.id = s.athlete_id
JOIN countries AS c
ON s.country_id = c.id
GROUP BY region, athlete_name;

-- Explanation: The highest gdp value for the world, the Max GDP for each country, and a row number assigned to each athlete by the number of medals they won. 

--------------------------------------------------------------------------------

-- Top athlete by Medals Won from each Area
SELECT
	region,
	athlete_name,
	total_golds
FROM (
	SELECT
	region,
	name AS athlete_name,
	SUM(gold) AS total_golds,
	ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(gold) DESC) AS row_num
	FROM summer_games_clean AS s
	JOIN athletes AS a
	ON a.id = s.athlete_id
	JOIN countries AS c
	ON s.country_id = c.id
	GROUP BY region, athlete_name) AS subquery
WHERE row_num = 1;

---------------------------------------------------------------------------------

-- GDP per Capita Performance Index
-- A calculation to compare efficiency metrics across groups. A performance index compares each row to a benchmark.
SELECT
	region,
	country,
	sum(gdp) / sum(pop_in_millions) as gdp_per_million,
	
	-- Total Pop in Millions Across All Countries
	SUM(SUM(gdp)) OVER() / SUM(SUM(pop_in_millions)) OVER() AS gdp_per_million_total,			  
	
	-- Performance Index Below
	(SUM(gdp) / SUM(pop_in_millions)) / (SUM(SUM(gdp)) OVER() / SUM(SUM(pop_in_millions)) OVER()) AS performance_index

FROM country_stats_clean as cs
JOIN countries as c
ON cs.country_id = c.id
WHERE year = '2016-01-01' AND gdp IS NOT NULL
GROUP BY region, country
ORDER BY gdp_per_million DESC;

-- Explanation: Dividing the gdp per million by the gdp per million total. Each country's GDP comparing to the global average. A value greater than 1 indicates a country is performing above the global average. 

--------------------------------------------------------------------------------

-- Month Over Month Comparison
-- The LAG() function outputs a value from an offset number previous to the current row, and LEAD() outputs the number after the current row.
SELECT
date_part('month', date) as month,		-- Returns 1 for Jan, 2 for Feb
country_id,

-- Views from each Country's Webpage promotion
sum(views) as month_views,
LAG(sum(views) OVER(PARTITION BY country_id ORDER BY date_part('month', date)) as previous_month_views,

-- Percent Change
sum(views) / LAG(sum(views)) OVER(partition by country_id order by date_part('month', date)) - 1 as percent_change

FROM web_data
WHERE date <= '2018-05-31'
GROUP BY month, country_id;

--------------------------------------------------------------------------------

-- Week Over Week Comparison
-- This requires looking back the past 7 days or forward 7 days
SELECT
date,
SUM(views) AS daily_views,

AVG(SUM(views)) OVER(ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg

FROM web_data
GROUP BY date;
	
---------------------------------------------------------------------------------

-- Weekly Average from Previuos Week
-- Calculate the current 7 day rolling average and the 7 day rolling average from a week prior.
SELECT
date,
weekly_avg,
	
LAG(weekly_avg,7) OVER(order by date) as weekly_avg_previous

FROM (
	SELECT
	date,
	sum(views) as daily_views,
	avg(sum(views)) OVER(order by date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as weekly_avg
	FROM web_data
	GROUP BY date) as subquery
ORDER BY date desc;

---------------------------------------------------------------------------------

-- Percent Change
-- By calculating for the previous row, the previous 6 days for a 7 day total average, we can now find the percent change week over week for a quick analysis of performance. 
SELECT
date,
weekly_avg,

LAG(weekly_avg,7) OVER(order by date) as weekly_avg_previous,

weekly_avg / LAG(weekly_avg,7) OVER(order by date) - 1 as percent_change

FROM (
	SELECT
	date,
	sum(views) as daily_views,
	avg(sum(views)) OVER(order by date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as weekly_avg
	FROM web_data
	GROUP BY date) as subquery
ORDER BY date desc;

--------------------------------------------------------------------------------

-- Tallest Athletes and % GDP by Region
-- The tallest athletes within their regions and the percentage of the worlds GDP attributed to their region. First we prepare the the row number to partition by country IDs and order by tallest athletes descending.
SELECT
country_id,
height,

ROW_NUMBER() OVER(partition by country_id order by height desc) as row_num

FROM winter_games as w
JOIN athletes as a
ON w.athlete_id = a.id
GROUP BY country_id, height
ORDER BY country_id, height desc;

---------------------------------------------------------------------------------

-- Tallest Athletes and % GDP by Region
-- The tallest athletes within their regions and the percentage of the worlds GDP attributed to their region.
SELECT
region,
round(avg(height),2) as avg_tallest,

round(sum(gdp)/sum(sum(gdp)) OVER(),3) as percent_world_gdp

FROM countries as c
JOIN (
	SELECT
	country_id,
	height,
	ROW_NUMBER() OVER(partition by country_id order by height desc) as row_num
	FROM winter_games as w
	JOIN athletes as a ON w.athlete_id = a.id
	GROUP BY country_id, height
	ORDER BY country_id, height desc) as subquery
ON c.id = subquery.country_id
JOIN country_stats as cs
ON cs.country_id = c.id
WHERE row_num = 1 
GROUP BY region;

---------------------------------------------------------------------------------


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


----------------------------------

-- Created on 8.13.2025

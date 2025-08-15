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























-- List of Events
SELECT DISTINCT event
FROM winter_games;


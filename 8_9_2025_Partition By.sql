-- Window Function: OVER(PARTITION BY x, y)
--Explanation: selecting country name with a window function, this query will return the season avg, per year, for each country name. 
SELECT
c.country_name,
m.season_year, 
AVG(home_goal + away_goal) 
  OVER(PARTITION BY m.season_year, c.country_name) AS season_avg_percountry --Window Function

FROM countries AS c
LEFT JOIN match_resulsts AS m
ON c.id = m.country_id

---------------------------------------------------------------------------------------------
-- Sliding Windows
-- Perform calculations relative to the Current Row

PRECEDING           -- Specify number of rows before input
FOLLOWING           -- Specify number of rows after input
  
UNBOUNDED PRECEDING -- Every row since the beginning
UNBOUNDED FOLLOWING -- Every row to the end

CURRENT ROW         -- Stops the calculation at the Current Row

---------------------------------------------------------------------------------------------

-- Running Total from oldest to Most recent
-- Calculates the sum of goals when Manchester city played as the home team during the 2011/2012 season
SELECT
date,
home_goal,
away_goal,
SUM(home_goal)
  OVER(ORDER BY date ROWS BETWEEN
      UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM match
WHERE hometeam_id = 8456 AND season = '2011/2012';


-- Running Total for the current and previous match only
SELECT
date,
home_goal,
away_goal,
SUM(home_goal)
  OVER(ORDER BY date ROWS BETWEEN
      1 PRECEDING AND CURRENT ROW) AS last2_homegoals
FROM match
WHERE hometeam_id = 8456 AND season = '2011/2012';

---------------------------------------------------------------------------------------------

-- Case Study
-- How badly did Manchester United lose in each match?

-- First we will start by filtering the data for the most important part.
WHERE m.season = '2014/2015'
  AND ((home.team_long_name = 'Manchester United' AND home.outcome = 'MU Loss')
  OR (away.team_long_name = 'Manchester United' AND away.outcome = 'MU Loss'));


-- Second we decide the outcome of the dataset
SELECT DISTINCT
date,
home.team_long_name AS home_team,
away.team_long_name AS away_team,
m.home_goal,
m.away_goal,

RANK() OVER(ORDER BY ABS(home_goal - away_goal) DESC) AS match_rank


-- Third we create JOINS with Common Table Expressions
FROM match AS m
LEFT JOIN home ON m.id = home.id
LEFT JOIN away ON m.id = away.id


-- Create the 

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

----------------------------------------------------------------------------------------------
-- Sliding Windows
-- Perform calculations relative to the Current Row

PRECEDING           -- Specify number of rows before input
FOLLOWING           -- Specify number of rows after input
  
UNBOUNDED PRECEDING -- Every row since the beginning
UNBOUNDED FOLLOWING -- Every row to the end

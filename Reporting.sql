/* Case Study: DataBallers
Entity-Relationship (E:R) diagram: A visual representation of database structure. 
The company will be involved in hosting an Olympic games event and would like a report on both the winter and summer sports to be centralized. Create a query that shows a unique number of events held for each sport. The UNION functions will combine both datasets and exclude null values. The result will be a column for sports and the number of events that occur within each sport.  */
SELECT
sport,
COUNT(DISTINCT event) AS events
FROM summer_games
GROUP BY sport
UNION
SELECT 
sport,
COUNT(DISTINCT event) AS events
FROM winter_games
GROUP BY sport
ORDER BY events DESC;

---------------------------------------Ch.2 Creating Reports---------------------------------------

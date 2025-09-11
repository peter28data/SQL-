------------------------------------- Data Associate Test -------------------------------------

-- Pearson Coefficient
-- Using a CTE to find the average sales price for all the years in the retail table for multiple retail locations to calculate the Pearson coefficient in the main query.
WITH sub_table AS (
  SELECT
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY price ASC) AS median,
    AVG(price) AS mean,
    STDDEV(price) AS std_dev
  FROM retail
)

SELECT
  (3 * (mean - median))/std_dev AS Pearson_Coefficient
FROM sub_table;


--------------------------------------------------------------------------


--
  

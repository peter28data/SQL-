------------------------------- Part 1: Match Strings & Numbers -------------------------------------

-- Replace 
UPDATE accounts
  SET user_name = REGEXP_REPLACE(username, '[dog, cat, fish]', '***', 'g');

-- Goal: Create a query to identify and replace any vulgar language before it is published in team chat to promote a friendlier user experience. 


--------------------------------------------------------------------------

-- Filtering, No changes to table
-- Match any string that starts with 'A' followed by a digit. Example A28
SELECT usernames,
FROM accounts
WHERE name SIMILAR TO 'A[0-9]%'
-- Match strings Ending in 'ing' or 'ed'
OR word SIMILAR TO '%(ing|ed)'

-- Goal: To investigate a username that is only known to start with A followed by a digit we can use 'A[0-9]%'. If we also know that this name ends in a certain pattern we can use '%(ing|ed)'. 

--------------------------------------------------------------------------

-- Full Regex Support
WHERE name ~ '^[A-Z]{3}[0-9]{2}$'
-- Case-Insensitive needs ~*
WHERE name ~* '^[a-z]+son$'


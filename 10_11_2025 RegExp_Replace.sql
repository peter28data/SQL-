------------------------ Task 1: Remove Special Characters --------------------------------------------------

UPDATE accounts
SET username = REGEXP_REPLACE(username, '[^A-Za-z0-9]', '', 'g')

-- [^A-Za-z0-9] = not a letter or number
-- Replaces all with ''.
-- "user!@#123" -> "user123"





-------------------------- Task 2: Swap First/Last Name ------------------------------------------------

UPDATE employees
SET full_name = regexp_replace(full_name, '(\w+),\s*(\w+)', '\2 \1');

-- Pattern: Lastname, Firstname
-- Replacement: Firstname Lastname using back references
-- "Doe, John" -> "John Doe"





-------------------------- Task 3: Extract year from Dates ------------------------------------------------

UPDATE orders
SET year_only = REGEXP_REPLACE(order_date::text, '(\d{4})-\d{2}-\d{2}', '\1')

-- (\d{4}) = capture 4-digit year
-- \1 = first capture group
-- "2024-09-23" -> "2024"





--------------------------------------------------------------------------

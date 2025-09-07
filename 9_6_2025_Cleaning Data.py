# Identify  duplicate rows
duplicate_rows = df[df.duplicated()]


# Remove
# Inplace=True modifies the original dataframe whereas False would create a new dataframe.
df.drop_duplicates(inplace=True)

# Validate 
# Running the same variable will return 0 rows because there are now no duplicates 
duplicate_rows = df[df.duplicated()]

-------------------------------------------------------------------------------------------------

# Summary Statistics
df['clicks'].describe()
# We find that there is a minimum value of -100 for number of clicks column, therefore we must investigate the problem.


# Investigate Outliers
negative_clicks = df[df['clicks']<0]
len(negative_clicks)
# Here we can use the length function to see how many rows have a negative value in the 'clicks' column. In this case it is two rows with negative values.

# Remove Outliers
# By assigning the dataframe variable to only values greater than or equal to 0, we can remove the rows with negative values
df = df[df['clicks']>=0]
check_if_any_negatives = df[df['clicks']<0]
check_if_any_negatives

---------------------------------------------------------------------------

# Replace Missing Values
# By using the fillna() function we can replace the missing values with the mean value. First we create a variable to define a list of the column names. Next we use a for loop to find the mean for the first item in the list and the second step of the for loop will be to replace all missing values with the mean found from the first step.

cols_missing_values = ['clicks', 'impression']
for col in cols_missing_values:
  mean_value = df[col].mean()
  df[col].fillna(mean_value,inplace=True)

# This replaces all missing values for the clicks column and then all the missing values in the impression column.

-------------------------------------


# Validate Missing Values were Replaced
df.info()
# We begain with 1000 entries and 899 non-null values for clicks and impression. However, after Validating our work we can only see 895 entries for ALL columns.

# This occurred due to the Removing Outliers < 0. Null values are seen as less than zero, therefore we removed the null values before being able to replace them.
























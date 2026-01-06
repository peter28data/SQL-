<h1 align="center">Peter Garay-Robles </h1>

<h3 align="center">A Data Engineer in SQL and Python.</h3>

----

# 📊 Database Management Portfolio 
## 📌 End-to-End SQL Analytics Project

## Executive Summary

This project demonstrates database management using SQL to clean, standardize, and analyze city service request data. 

The Goal: Transform inconsistent records into reliable, query-ready tables that support accurate reporting and decision-making through the following steps below.

1. Trimmed Data to remove numbers from street names
2. Split Strings to remove 'St, Ave, Ln'
3. Aggregated by Noise-Type Categories

---

## 🧪 Business Problem 

Open-source data from real Washington D.C. 311 Service-Request calls is often collected from multiple sources and contains inconsistent formatting, duplicate values, and non-standard category labels. 

These issues make it difficult for management to accurately compare sectors across service request categories. The messy data will be cleaned in three steps and create a visual.

---

![noise related](https://github.com/peter28data/SQL/blob/d828cb9eeacb768d5d4bae8303bfc66c1c8243f8/images/noise_related_requests_category74.png)

----

1️⃣ First, the code below:
- **Standardizes the Data** by removing all unwanted characters from street names such as numbers
  
----

![standardize values](https://github.com/peter28data/SQL/blob/main/images/trim_streets.png)

---

2️⃣ Second, the code below:
- **Splits Strings** to report which streets receive the most calls
  
----

![split strings](https://github.com/peter28data/SQL/blob/main/images/split_part.png)

----

3️⃣ Third, the code below:

- **Aggregating Service Requests** by Noise-Type Category

---

![category Count](https://github.com/peter28data/SQL/blob/main/images/category_aggregated.png)

----

The final output enables stakeholders to clearly understand which request categories are most common in each street and where operational resources may be required.

A visual can now be generated to count the number of Service-Request calls in each category.

---

## 📊 Chat-GPT Graph vs Senior Analyst
The initial graph below is the result of using Chat-GPT to produce a visual for Noise-Related Service-Request categories. 

The second graph are the changes produced by prompt engineering at a senior analyst level. 

---
![city response](https://github.com/peter28data/SQL/blob/d828cb9eeacb768d5d4bae8303bfc66c1c8243f8/images/city_noise_responses_categories10.6.png)

---

## 🧩 Changes Made: Chat-GPT Graph vs Senior Analyst
1. Red-dash marker for average across all categories 

2. Integrated shaded coloring with Count of Categories

3. Figure size changed from (10,6) to (7,4) for readability

---

![noise related](https://github.com/peter28data/SQL/blob/d828cb9eeacb768d5d4bae8303bfc66c1c8243f8/images/noise_related_requests_category74.png)

---

## 🎯 Recap: SQL Queries to Clean Data
1. Trimmed Data to remove numbers from street names
2. Split Strings to remove 'St, Ave, Ln'
3. Aggregated by Noise-Type Categories

---

## 🧪 New Business Problem: Translate to Data 
1. Identifying deliverable metrics for Solution

Business Problem: Call Center Representatives have reported to management they cannot always receive contact information such as email or phone numbers when they process Service-Request calls in Washington D.C. due to the fast paced nature of calls. 

Business Solution: Investigate the Database to see if the *Proportion* of Service-Request calls with and without contact information vary between sectors or due to the natures of calls, medium or high priority, justify the lack of contact information. 

---

![casting](https://github.com/peter28data/SQL/blob/main/images/proportion_priority.png)

---

## 🧪 Next Step: SQL Queries to Analyze Data
2. Creative Strategy for Identifying Contact Information

SQL operators such as 'LIKE' can be used to return values based on specific matching criteria. Integrating this operator with '%@%' will return a TRUE or FALSE if somewhere in the description box for the Service-Requests contains a value with any numbers of characters before and after the '@' such as "john123@gmail" or "jane123@outlook".

(Advanced) Normally, the CAST function is used to change the data type of values. However, a senior analyst can understand a creative strategy when converting TRUE and FALSE values to numeric indicators using a CAST function, enabling straightforward aggregation. As a result, we can quanitify how many records contain email adresses and calculate their proportion, as shown below. 

---

![proportion](https://github.com/peter28data/SQL/blob/main/images/casting_like_integer.png)

---

Now we can create a temporary table to not alter the original database and store the cleaned data. 

---

![temporary table](https://github.com/peter28data/SQL/blob/main/images/temp_table_where.png)

---

## 📌 Managing Mislabeled Categories

SPLIT_PART Function: The category labels such as "Snow Removal-Tree Obstruction" have been standardized to "Snow Removal" by removing part of the string.

- WHERE & LIKE clauses in the SQL query are used to identify Categories that may have been logged in differently
- UPDATE clause will create change any variation of specific categories to be spelled in a uniform way

---

![update table](https://github.com/peter28data/SQL/blob/main/images/updated_temp_table.png)

----

## 🧩Missing Values Management ##
1. CASE WHEN Function: Utilized above to handle complex for one feature such as changing another feature in dataset if the other is before a timeline of 2021.


2. COALESCE Function: Utilized below for less tasks such as removing unwanted characters, changing data type, and lower casing but for four features instead of one.

---

![case replace](https://github.com/peter28data/SQL/blob/main/images/case_when_missing.png)

---

![coalesce](https://github.com/peter28data/SQL/blob/main/images/coalesce_columns.png)

---
## 🤝 Done!  Thank you for Reading
For questions or collaboration opportunities:

📧 peter.garayrobles@gmail.com  
🔗 Portfolio Link: https://github.com/peter28data/SQL-/blob/main/8_10_2025_Cleaning%20Data.sql

---

### ⭐ If you like this project, please star the repo!


<p align="left"> <a href="https://github.com/ryo-ma/github-profile-trophy"><img src="https://github-profile-trophy.vercel.app/?username=ryo-ma&title=Commit" alt="peter28data" /></a> </p>



<h3 align="left">Languages and Tools:</h3>
<p align="left"> <a href="https://git-scm.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="40" height="40"/> </a> <a href="https://pandas.pydata.org/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/2ae2a900d2f041da66e950e4d48052658d850630/icons/pandas/pandas-original.svg" alt="pandas" width="40" height="40"/> </a> <a href="https://www.postgresql.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/postgresql/postgresql-original-wordmark.svg" alt="postgresql" width="40" height="40"/> </a> <a href="https://www.python.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="40" height="40"/> </a> <a href="https://scikit-learn.org/" target="_blank" rel="noreferrer"> <img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Scikit_learn_logo_small.svg" alt="scikit_learn" width="40" height="40"/> </a> <a href="https://seaborn.pydata.org/" target="_blank" rel="noreferrer"> <img src="https://seaborn.pydata.org/_images/logo-mark-lightbg.svg" alt="seaborn" width="40" height="40"/> </a> </p>

- 🔭 I’m currently working on **Customer Segmentation in SQL.**

- 💬 Ask me about **SQL Common Table Expressions (CTE), Window Functions, Regex**

- 📫 How to reach me **peter.garayrobles@gmail.com**

<h3 align="left">Connect with me @ peter.garayrobles.com</h3>
<p align="left">
</p>


<p><img align="center" src="https://github-readme-streak-stats.herokuapp.com/?user=peter28data&" alt="peter28data" /></p>


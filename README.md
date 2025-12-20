<h1 align="center">Hi 👋, I'm Peter </h1>
<h3 align="center">A dedicated analyst in SQL, Tableau, and Python.</h3>

<p align="left"> <a href="https://github.com/ryo-ma/github-profile-trophy"><img src="https://github-profile-trophy.vercel.app/?username=peter28data" alt="peter28data" /></a> </p>


<h3 align="left">Languages and Tools:</h3>
<p align="left"> <a href="https://git-scm.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="40" height="40"/> </a> <a href="https://pandas.pydata.org/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/2ae2a900d2f041da66e950e4d48052658d850630/icons/pandas/pandas-original.svg" alt="pandas" width="40" height="40"/> </a> <a href="https://www.postgresql.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/postgresql/postgresql-original-wordmark.svg" alt="postgresql" width="40" height="40"/> </a> <a href="https://www.python.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="40" height="40"/> </a> <a href="https://scikit-learn.org/" target="_blank" rel="noreferrer"> <img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Scikit_learn_logo_small.svg" alt="scikit_learn" width="40" height="40"/> </a> <a href="https://seaborn.pydata.org/" target="_blank" rel="noreferrer"> <img src="https://seaborn.pydata.org/_images/logo-mark-lightbg.svg" alt="seaborn" width="40" height="40"/> </a> </p>

- 🔭 I’m currently working on **Customer Segmentation in SQL.**

- 💬 Ask me about **SQL Common Table Expressions (CTE), Window Functions, Regex**

- 📫 How to reach me **peter.garayrobles@gmail.com**

<h3 align="left">Connect with me @ peter.garayrobles.com</h3>
<p align="left">
</p>


<p><img align="center" src="https://github-readme-streak-stats.herokuapp.com/?user=peter28data&" alt="peter28data" /></p>


----


# 📊 Database Management Portfolio — SQL

## Executive Summary

This project demonstrates database management using SQL to clean, standardize, and analyze city service request data. The goal is to transform inconsistent raw records into reliable, query-ready tables that support accurate reporting and decision-making.

☆ Standardized inconsistent category and mislabeled fields for analysis  
☆ Built aggregation queries to count requests by city and category  


---

![noise related](https://github.com/peter28data/SQL/blob/main/noise_related_requests_category74.png)

---


![category Count](https://github.com/peter28data/SQL-/blob/main/category_count.png)

----

## Business Problem

City service request data is often collected from multiple sources and contains inconsistent formatting, duplicate values, and non-standard category labels. These issues make it difficult to accurately compare service request categories across streets and cities.

First the code below:
- **Standardizes the Data** by removing all unwanted characters
  
----

![standardize values](https://github.com/peter28data/SQL-/blob/main/standardize_values.png)

----
Second the code below:
- **Splits Strings** to report which streets receive the most calls
- **Aggregating service requests** by street name
----

![split strings](https://github.com/peter28data/SQL-/blob/main/split_strings_count.png)

----

The final output enables stakeholders to clearly understand which request categories are most common in each street and where operational resources may be required.


---


## Data Processing Flow

**Flow Overview:**

↳ Final visual above built from Inital graph below

↳ Red marker for average across categories, title size, and figure size changed

↳ Requests grouped and counted by category  

---

![city response](https://github.com/peter28data/SQL/blob/main/city_noise_responses_categories10.6.png)

---


![temporary table](https://github.com/peter28data/SQL-/blob/main/temporary_table.png)

![update table](https://github.com/peter28data/SQL-/blob/main/update_values.png)

----

## Tools & Techniques
- SQL (CTEs, aggregations, string functions)
- Data standardization and validation

----

![case replace](https://github.com/peter28data/SQL/blob/main/replace_null_before_year.png)

---

## Missing Values Management ##
1. Case When Function: Utilized above to handle complex for one feature such as changing another feature in dataset if the other is before a timeline of 2021. 
3. Coalesce Function: Utilized below for less tasks such as removing unwanted characters, changing data type, and lower casing but for four features instead of one.

---

![coalesce](https://github.com/peter28data/SQL/blob/main/clean_categorical_data.png)

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
↳ Raw city request data ingested into staging tables  
↳ Category and city values cleaned and standardized  
↳ Requests grouped and counted by city and category  
↳ Final tables prepared for reporting and visualization  


---


## Tools & Techniques
- SQL (CTEs, aggregations, string functions)
- Data standardization and validation
- Relational database design principles

----

![temporary table](https://github.com/peter28data/SQL-/blob/main/temporary_table.png)

![update table](https://github.com/peter28data/SQL-/blob/main/update_values.png)

----

### EDA
# Encoding Techniques for Categorical variables- pandas & scikit-learn
from sklearn import preprocessing
encoder = preprocessing.LabelEncoder()
new_vals = encoder.fit_transform(laptops['Company'])

# Encoding: One-hot encode 'Company' column
laptops2 = pd.get_dummies(data=laptops2,
                            columns=['Company'])
  
### Calculating sample size
from statsmodels.stats.power import zt_ind_solve_power
import statsmofels.stats.proportion as prop
zt_ind_solve_power()
tt_ind_solve_power()
proportion_effectsize()



# Example: by counting how many models are from each company...
company_count = df['Company'].value_counts()
# A visual can be made by taking the index
sns.barplot(company_count.index, company_count.values)
# A visual to see the price distribution for 3 different companies
df.boxplot('Price', 'Company', rot=30, figsize=(12,8), vert=False)

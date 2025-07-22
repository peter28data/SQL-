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
import statsmodels.stats.proportion as prop
zt_ind_solve_power()
tt_ind_solve_power()
proportion_effectsize()
std_effect = prop.proportion_effectsize(.20, .25)
zt_ind_solve_power(effect_size=std_effect,
                   nobs1=None,
                   alpha=.05,
                   power=.80)   #Desired sample of 1092, raising the power to .95 would require 1808 sample size
# calculating sample size
from statsmodels.stats.proportion import proportion_effectsize
std_effect = proportion_effectsize(.20, .25)
# Visualizing sample sizes based on ttests and sample size, on the x-axis, needed for the level of power, on the y-axis
sample_size = np.array(range(5,100))
effect_sizes = np.array([0.2, 0.5, 0.8])
from statsmodels.stats.power import TTestIndPower
results = TTestIndPower()
results.plot_power(dep_var='nobs',
                   nobs=sample_sizes,
                   effect_size=effect_sizes)
plt.show()

### Multiple Testing
from statsmodels.sandbox.stats.multicomp import multiplesets
p_adjusted = multipletests(pvals,
                           alpha=.05,
                           method='bonferroni')
print(p_adjusted[0])
print(p_adjusted[1])

### Linear Regression
from sklearn.linear_model import LinearRegression
X_train = np.array(weather['Humidity9am']).reshape(-1,1)
y_train = weather['Humidity3pm']
lm = LinearRegression()
lm.fit(X_train, y_train)
preds = lm.predict(X_train)
coef = lm.coef_
print(coef)

# Logistic Regression
from sklearn.linear_model import LogisticRegression
clf = LogisticRegression()
clf.fit(X_train, y_train)
acc = clf.score(X_test, y_test)
print(acc)
coefs = clf.coef_
print(coefs)

### Missing Data and Outliers
df.dropna(inplace=True)   # Drop the whole row
df.fillna()               # imputation with average, forward fill, etc
df.isnull()               # T/F if row has any null values
nulls = laptops[laptops.isnull().any(axis=1)]   # slices DF for entire rows with any null values
laptops.fillna(0, inplace=True)
laptops.fillna(laptops.median(), inplace=True)
laptops.dropna(inplace=True)

mean, std = laptops['Price'].mean(), laptops['Price'].std()
cut_off = std * 3
lower, upper = mean - cutoff, mean + cut_off
print(lower, 'to', upper)    # Interquartile Range
outliers = laptops[(laptops['Price'] > upper) | (laptops['Price'] < lower)]
print(outliers)             # Identify entire rows with outliers
laptops = laptops[(laptops['Price'] <= upper) | (laptops['Price'] >= lower)]
print(laptops)              # Only data within IQR

plt.scatter(X, y)
plt.plot(np.sort(X), preds) # Simple Linear Regression line
plt.plot(np.sort(X), preds2)  # Higher-complexity regression line
plt.show()

### Ch.1: Conditional Probabilities such as Bayes Theorem, Central Limit Theorem. Ch.2: Desciptive statistics, Visualizing Categorical data and Encoding techniques, Multivariate relationships. Ch.3: Confidence intervals, hypothesis testing, power analysis(sample size), multiple comparisons (adjusted p-value). Ch.4: Linear Regression, Logisitic Regression, Missing data and outliers, Bias-Variance tradeoff. 






----------------------------------------------------------------------------------------------------------------
# Example: by counting how many models are from each company...
company_count = df['Company'].value_counts()
# A visual can be made by taking the index
sns.barplot(company_count.index, company_count.values)
# A visual to see the price distribution for 3 different companies
df.boxplot('Price', 'Company', rot=30, figsize=(12,8), vert=False)

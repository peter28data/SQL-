### Calculating sample size
from statsmodels.stats.power import zt_ind_solve_power
import statsmodels.stats.proportion as prop
#zt_ind_solve_power()
#tt_ind_solve_power()
#proportion_effectsize()
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

# -------------------------------------------------------------------------------------------------------------
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

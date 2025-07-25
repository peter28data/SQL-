### PROBABILITY AND RANDOM VARIABLES
#1 Create an array of 100,000 numbers sampled from an Exponential distribution with rate parameter equal to 56.
import numpy as np
sample = np.random.exponential(1/56,100000)
print(sample)

#3 Draw a sample of 20,000 numbers from a Standard Normal distribution.
import numpy as np
from scipy.stats import norm
sample = norm.rvs(0, 1, size=20000)
print(sample)

#6 To calculate the cumulative probability of 40 in a Empirical Cumulative distribution function (ECDF), the data sample is in an array named x.
from statsmodels.distributions.empirical_distribution import ECDF
ecdf = ECDF(x)
print(ecdf(40))

#11 Create an array of one million numbers sampled from a normal distribution with a mean equal to 30 and standard deviation of 5. This returns random numbers in the 8th decimal place. 
import numpy as np
from scipy.stats import norm
sample = np.random.normal(30, 5, 1000000)
print(sample)

# ---------------------------------------------------------------------------------------------------
### GRAPHICS FOR STATISTICS
#2 Performing exploratory analysis to establish factors that contribute to the value of a second hand car. The pairplot shows a Scatterplot and a Kernel Density Plot to compare each variable with every other variable to display any relationships. 
import matplotlib.pyplot as plt
import seaborn as sns
sns.pairplot(valuation[['age', 'mpg', 'value']],
             diag_kind = 'kde')
plt.show()

### RANDOM SAMPLING
#4 For each of the next 50 visitors to your website you want to randomly assign them to either group A or B to establish the goal of customers seeing different versions of the landing page.
import numpy as np
groups = ['A', 'B']
assignment = np.random.choice(groups, 50)
print(assignment)

#5 Ensure that the same sample of random numbers are generated each time the code is executed. By setting a random seed and the parameters from 0 to 11, the code will execute 5 variables in a list and although it will be random, the random seed ensures it is replicable. 
import numpy as np
np.random.seed(42)
sample = np.random.randint(0, 11, 5)

#10 Perform a simulation of purchasing three seperate chocolate bars from a local store with results in a list of 3 items 'Lose' or 'Win'.
import numpy as np
purchases = np.random.choice(chocolate, 3, replace=False)
print(purchases)

# ---------------------------------------------------------------------------------------------------
#13 A bootstrapped sample of mean lap times for Formula 1 race cars, containd in an array "bootstraps". Generate a 95% confidence interval of the boostrapped lap times. 
import numpy as np
lower = np.quantile(bootstraps, 0.025)
upper = np.quantile(bootstraps, 0.975)

### EXPERIMENTS AND SIGNIFICANCE TESTING
#8 Is there a statistically significant difference in mean calcium intake in patients with normal bone density as compared to patients with osteopenia and osteoporosis?
from scipy import stats
results = stats.f_oneway(normal, osteoenia, osteoporosis)
print("statistic: {}".format(results[0]))
print("p-value: {}".format(results[1]))

#9 Test the hypothesis that the average spend in the small grocery store is not $8.
from scipy import stats
test = stats.ttest_1samp(spend, 8)
print(test.pvalue.round(3))

#12 Is there a significant difference in cholesterol levels between males and females?
from scipy import stats
results = stats.ttest_ind(males, females)
print("statistic: {}".format(results[0]))
print("p-value: {}".format(results[1]))


### Hypothesis Testing with Men's and Women's Soccer Matches
# Imports
import pandas as pd
import matplotlib.pyplot as plt
import pingouin
from scipy.stats import mannwhitneyu

# Load men's and women's datasets
men = pd.read_csv("men_results.csv")
women = pd.read_csv("women_results.csv")

# Filter the data for the time range and tournament
men["date"] = pd.to_datetime(men["date"])
men_subset = men[(men["date"] > "2002-01-01") & (men["tournament"].isin(["FIFA World Cup"]))]
women["date"] = pd.to_datetime(women["date"])
women_subset = women[(women["date"] > "2002-01-01") & (women["tournament"].isin(["FIFA World Cup"]))]

# Create group and goals_scored columns
men_subset["group"] = "men"
women_subset["group"] = "women"
men_subset["goals_scored"] = men_subset["home_score"] + men_subset["away_score"]
women_subset["goals_scored"] = women_subset["home_score"] + women_subset["away_score"]

# Determine normality using histograms
men_subset["goals_scored"].hist()
plt.show()
plt.clf()

# Goals scored is not normally distributed, so use Wilcoxon-Mann-Whitney test of two groups
men_subset["goals_scored"].hist()
plt.show()
plt.clf()

# Combine women's and men's data and calculate goals scored in each match
both = pd.concat([women_subset, men_subset], axis=0, ignore_index=True)

# Transform the data for the pingouin Mann-Whitney U t-test/Wilcoxon-Mann-Whitney test
both_subset = both[["goals_scored", "group"]]
both_subset_wide = both_subset.pivot(columns="group", values="goals_scored")

# Perform right-tailed Wilcoxon-Mann-Whitney test with pingouin
results_pg = pingouin.mwu(x=both_subset_wide["women"],
                          y=both_subset_wide["men"],
                          alternative="greater")

# Alternative SciPy solution: Perform right-tailed Wilcoxon-Mann-Whitney test with scipy
results_scipy = mannwhitneyu(x=women_subset["goals_scored"],
                             y=men_subset["goals_scored"],
                             alternative="greater")

# Extract p-value as a float
p_val = results_pg["p-val"].values[0]

# Determine hypothesis test result using sig. level
if p_val <= 0.01:
    result = "reject"
else:


### Exploring Experimental Design in the Energy Field
-Factorial designs, studying multiple independent variables, and 
-Randomized block designs, grouping experimental units to control variance
# Import required libraries
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import f_oneway, ttest_ind
from statsmodels.sandbox.stats.multicomp import multipletests

# Load datasets
energy_design_a = pd.read_csv("energy_design_a.csv")
energy_design_b = pd.read_csv("energy_design_b.csv")

# Determine the correct experimental design by reviewing the columns available in both datasets
# There also appears to be some blocking by geographical region inferred 
energy_design_a.head()
energy_design_b.head()
design = "randomized_block"  # Correct answer given the experimental setup

# Select the appropriate dataset
data = energy_design_b

# Create a boxplot to visualize CO2 emissions by geographical region and fuel source
sns.boxplot(
    x='Geographical_Region', 
    y='CO2_Emissions', 
    hue='Fuel_Source', 
    data=data
)
plt.title('CO2 Emissions by Geographical Region and Fuel Source')
plt.xlabel('Geographical Region')
plt.ylabel('CO2 Emissions (tons)')
plt.show()

# Identify highest median CO2 emission region and source after viewing the plot
highest_co2_region = "South"
highest_co2_source = "Coal"

# Group by Geographical Region and apply ANOVA to check significance
test_results = data.groupby('Geographical_Region').apply(
    lambda x: f_oneway(
        x[x['Fuel_Source'] == 'Natural_Gas']['CO2_Emissions'],
        x[x['Fuel_Source'] == 'Biofuel']['CO2_Emissions'],
        x[x['Fuel_Source'] == 'Coal']['CO2_Emissions']
    )
)

print("Test Results:", test_results)

# Ensure test_results show significant results (one or more with p-value < 0.05)
if any(result.pvalue < 0.05 for result in test_results):
    bonferroni_p_values = []

    # Perform pairwise comparisons for Bonferroni correction
    for zone in ['North', 'South', 'East', 'West']:
        fuels = ['Natural_Gas', 'Biofuel', 'Coal']
        comparisons = [(fuels[i], fuels[j]) for i in range(len(fuels)) for j in range(i + 1, len(fuels))]

        for fuel1, fuel2 in comparisons:
            group1 = data[(data['Geographical_Region'] == zone) & (data['Fuel_Source'] == fuel1)]['CO2_Emissions']
            group2 = data[(data['Geographical_Region'] == zone) & (data['Fuel_Source'] == fuel2)]['CO2_Emissions']
            _, p_val = ttest_ind(group1, group2)
            bonferroni_p_values.append(p_val)

    # Apply Bonferroni correction for multiple comparisons
    diff_results = multipletests(bonferroni_p_values, alpha=0.05, method='bonferroni')

print("Bonferroni Corrected P-values:", diff_results[1])
    result = "fail to reject"

result_dict = {"p_val": p_val, "result": result}
 

### Data-Driven Decisions with A/B Testing
# IMPORT PACKAGES
import pandas as pd
from scipy.stats import chisquare
from pingouin import ttest
from statsmodels.stats.proportion import proportions_ztest

# DEFINE FUNCTIONS
def estimate_effect_size(df: pd.DataFrame, metric: str) -> float:
    """
    Calculate relative effect size

    Parameters:
    - df (pd.DataFrame): data with experiment_group ('control', 'variant') and metric columns.
    - metric (str): name of the metric column

    Returns:
    - effect_size (float): average treatment effect (effect size)
    """
    avg_metric_per_group = df.groupby('experiment_group')[metric].mean()
    effect_size = avg_metric_per_group['variant'] / avg_metric_per_group['control'] - 1
    return effect_size

# FIXED PARAMETERS
confidence_level = 0.90  # Set desired confidence level (90%)
alpha = 1 - confidence_level  # Significance level for hypothesis tests

# LOAD DATA
users = pd.read_csv('users_data.csv') # Load user and experiment group data
sessions = pd.read_csv('sessions_data.csv') # Load session/booking data

# JOIN DATA
# Merge on user ID to enrich sessions with user experiment group
sessions_x_users = sessions.merge(users, on = 'user_id', how = 'inner')

# COMPUTE PRIMARY METRIC
# Binary conversion flag: 1 if booking occurred, 0 otherwise
sessions_x_users['conversion'] = sessions_x_users['booking_timestamp'].notnull().astype(int)

# SAMPLE RATIO MISMATCH TEST
# Check if the number of users in each experiment group is balanced (a basic A/A sanity check)
groups_count = sessions_x_users['experiment_group'].value_counts()
print(groups_count)

n = sessions_x_users.shape[0] # Total sample size
srm_chi2_stat, srm_chi2_pval = chisquare(f_obs = groups_count, f_exp = (n/2, n/2))
srm_chi2_pval = round(srm_chi2_pval, 4)
print(f'\nSRM\np-value: {srm_chi2_pval}') # If p < alpha, there's likely a sampling issue issue
    
# EFFECT ANALYSIS - PRIMARY METRIC
# Compute success counts and sample sizes for each group
success_counts = sessions_x_users.groupby('experiment_group')['conversion'].sum().loc[['control', 'variant']]
sample_sizes = sessions_x_users['experiment_group'].value_counts().loc[['control', 'variant']]

# Run Z-test for proportions (binary conversion metric)
zstat_primary, pval_primary = proportions_ztest(
    success_counts,
    sample_sizes,
    alternative = 'two-sided',
)
pval_primary = round(pval_primary, 4)

# Estimate effect size for the conversion metric
effect_size_primary = estimate_effect_size(sessions_x_users, 'conversion')
effect_size_primary = round(effect_size_primary, 4)
print(f'\nPrimary metric\np-value: {pval_primary: .4f} | effect size: {effect_size_primary: .4f}')
    
# EFFECT ANALYSIS - GUARDRAIL METRIC
# T-test on time to booking for control vs variant
stats_guardrail = ttest(
    sessions_x_users.loc[(sessions_x_users['experiment_group'] == 'control'), 'time_to_booking'],
    sessions_x_users.loc[(sessions_x_users['experiment_group'] == 'variant'), 'time_to_booking'],
    alternative='two-sided',
)
pval_guardrail, tstat_guardrail = stats_guardrail['p-val'].values[0], stats_guardrail['T'].values[0]
pval_guardrail = round(pval_guardrail, 4)

# Estimate effect size for the guardrail metric
effect_size_guardrail = estimate_effect_size(sessions_x_users, 'time_to_booking')
effect_size_guardrail = round(effect_size_guardrail, 4)
print(f'\nGuardrail\np-value: {pval_guardrail} | effect size: {effect_size_guardrail}')

# DECISION
# Primary metric must be statistically significant and show positive effect (increase)
criteria_full_on_primary = (pval_primary < alpha) & (effect_size_primary > 0)

# Guardrail must either be statistically insignificant or whow positive effect (decrease)
criteria_full_on_guardrail = (pval_guardrail > alpha) | (effect_size_guardrail <= 0)

# Final launch decision based on both metrics
if criteria_full_on_primary and criteria_full_on_guardrail:
    decision_full_on = 'Yes'
    print('\nThe experiment results are significantly positive and the guardrail metric was not harmed, we are going full on!')
else:
    decision_full_on = 'No'
    print('\nThe experiment results are inconclusive or the guardrail metric was harmed, we are pulling back!')



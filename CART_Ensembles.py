# Import Decsion Tree Classifier to predict whether a tumor is lamignant or benign based on the mean radius of the tumor and its mean number of concave points
from sklearn.tree import DecisionTreeClassifier
SEED = 1
dt = DecisionTreeClassifier(max_depth=6, random_state=SEED)
dt.fit(X_train, y_train)
y_pred = dt.predict(X_test)
print(y_pred[0:5])
from sklearn.metrics import accuracy_score
y_pred = predict(X_test)
acc = accuracy_score(y_test, y_pred)
print("Test set accuracy: {:.2f}".format(acc))
from sklearn.linear_model import LogisticRegression
logreg = LogisticRegression(random_state=1)
logreg.fit(X_train, y_train)
clfs = [logreg, dt]
plot_labeled_decision_regions(X_test, y_test, clfs)

# ---------------------------------------------------------------------------------------------------
# Classification Tree Learning
# Each node the data is split based on maximizing Information Gain. Entropy as a criterion for Breast Cancer classification dataset
from sklearn.tree import DecisionTreeClassifier
dt_entropy = DecisionTreeClassifier(max_depth=8,
                                    criterion='entropy',
                                    random_state=1)
dt_entropy.fit(X_train, y_train)
from sklearn.metrics import accuracy_score
y_pred = dt_entropy.predict(X_test)
accuracy_entropy = accuracy_score(y_test, yield)
print(f'Accuracy achieved by using entropy: {accuracy_entropy:.3f}')
print(f'Accuracy achieved by using entropy: {accuracy_gini:.3f}')

# Decision Tree Regression
# To capture non-linear trends from data
from sklearn.tree import DecisionTreeRegressor
dt = DecisionTreeRegressor(max_depth=8,
                           min_samples_leaf=0.13,
                           random_state=3)
dt.fit(X_train, y_train)
from sklearn.metrics import mean_squared_error as MSE 
y_pred = dt.predict(X_train)
mse_dt = MSE(y_test, y_pred)
rmse_dt = mse_dt**(1/2)
print("Test set RMSE of dt: {:.2f}".format(rmse_dt))

# Linear Regression vs Regression Tree on Non-linear Trend
y_pred_lr = lr.predict(X_test)
mse_lr = MSE(y_pred_lr, y_test)
rmse_lr mse_lr**(1/2)
print('Linear Regression test set RMSE: {:.2f}'.format(rmse_lr))
print('Regression Tree test set RMSE: {:.2f}'.format(rmse_dt))

# ---------------------------------------------------------------------------------------------------
# Generalization Error, Bias-Variance Tradeoff
# Underfitting: not flexivle enough, Overfitting: fits the training set noise too much
# GE = bias^2 + variance + noise
from sklearn.model_selection import train_test_split
SEED = 1 
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=SEED)
dt = DecisionTreeRegressor(max_depth=4, min_samples_leaf=0.26, random_state=SEED)
MSE_CV_scores = - cross_val_score(dt, X_train, y_train, cv=10, 
                                  scoring='neg_mean_squared_error',
                                  n_jobs=-1)
RMSE_CV = (MSE_CV_scores.mean())**(1/2)
print('CV RMSE: {:.2f}'.format(RMSE_CV))
from sklearn.metrics import mean_squared_error as MSE 
dt.fit(X_train, y_train)
y_pred_train = dt.predict(X_train)
RMSE_train = (MSE(y_train, y_pred_train))**(1/2)
print('Train RMSE: {:.2f}'.format(RMSE_train))

# Ensemble Learning
SEED = 1 
lr = LogisticRegression(random_state=SEED)
knn = KNN(n_neighbors=27)
dt = DecisionTreeClassifier(min_samples_leaf=0.13,
                            random_state=SEED)
classifiers = [('Logistic Regression', lr),
               ('K Nearest Neighbours', knn),
               ('Classification Tree', dt)]

# Evaluate classifiers
for clf_name, clf in classifiers:
  clf.fit(X_train, y_train)
  y_pred = clf.predict(X_train)
  accuracy = accuracy_score(y_test, y_pred)
  print('{:s} : {:.3f}'.format(clf_name, accuracy))

# Take the outputs of the models and assign labels by majority voting
from sklearn.ensemble import VotingClassifier
vc = VotingClassifier(estimators=classifiers)
vc.fit(X_train, y_train)
y_pred = vc.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print('Voting Classifier: {:.3f}'.format(accuracy))


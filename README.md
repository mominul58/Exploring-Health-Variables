# Exploring Health Variables: Understanding BMI, Glucose, and Diabetes Risk Factors

## Author: Md. Mominul Islam

### Aim of the Dataset
This dataset explores various health-related variables to analyze the associations between BMI, glucose levels, and diabetes risk factors. The primary goal is to understand which factors most significantly contribute to diabetes risk and how they interact with each other. The analysis provides insights into potential risk factors and helps guide interventions for diabetes prevention.

---

## **Task 1: How Blood Pressure Influences Body Mass Index (BMI)**
### 1.1 Correlation Between Blood Pressure and BMI
- The correlation coefficient between blood pressure and BMI is **0.281**, indicating a weak to moderate positive relationship.
- As blood pressure increases, BMI also tends to rise, but other factors also contribute significantly to BMI variation.

### 1.2 Regression Analysis
A simple linear regression model was applied:
```math
BMI = 20.88 + 0.159 × Blood Pressure
```
- **Key Findings:**
  - Blood Pressure has a statistically significant relationship with BMI (p-value < 0.001).
  - The model explains **7.9%** of the variance in BMI (R² = 0.079), suggesting other factors play a bigger role.

### 1.3 Visual Representation
- A scatter plot with a regression trendline confirms an upward trend but also suggests high variability.

### 1.4 Model Performance Evaluation
- **Mean Squared Error (MSE):** 43.472
- **Root Mean Squared Error (RMSE):** 6.593
- The model’s predicted BMI values are, on average, **within 6.59 BMI units** of the actual values.

### 1.5 Conclusion
- Higher blood pressure is associated with higher BMI, but the relationship is weak.
- Lifestyle modifications addressing both BMI and blood pressure can lead to better health outcomes.

---

## **Task 2: How Other Variables Affect a Patient's Glucose Levels**
### 2.1 Significant Variables Affecting Glucose Levels
A **Random Forest model** was used to predict glucose levels. The most significant predictors were:
- **Insulin:** Strongest predictor of glucose levels.
- **Age:** Older individuals typically experience reduced insulin sensitivity.
- **BMI:** Strongly associated with higher glucose levels.

### 2.2 Moderately Influential Variables
- **Skin Thickness:** An indirect marker of body fat, which affects glucose metabolism.
- **Blood Pressure:** Moderate correlation with glucose levels due to metabolic syndrome.

### 2.3 Least Influential Variables
- **Pregnancy history** and **Diabetes Pedigree Function** (genetic predisposition) had the least impact on glucose levels.

### 2.4 Correlation Insights
- **Glucose & Insulin:** 0.42 (strong correlation)
- **Glucose & BMI:** 0.28 (moderate correlation)
- **Glucose & Blood Pressure:** 0.22 (moderate correlation)
- **Genetic factors and pregnancy history** showed weak associations.

### 2.5 Model Evaluation
- **Mean Squared Error (MSE):** 560.8078
- The model captures glucose-related patterns, but further tuning could improve accuracy.

---

## **Task 3: Which Variable Plays the Most Important Role in Diabetes Risk?**
A **Random Forest model** was used to determine key predictors of diabetes risk.

### 3.1 Variable Importance
| Variable | Mean Decrease Accuracy | Mean Decrease Gini |
|----------|------------------------|--------------------|
| **Glucose** | 45.38 | 88.31 |
| **BMI** | 21.19 | 56.24 |
| **Age** | 17.85 | 47.12 |
| **Pregnancies** | 11.50 | 28.27 |
| **Insulin** | 9.56 | 31.10 |
| **Diabetes Pedigree Function** | 7.16 | 42.88 |
| **Skin Thickness** | 2.01 | 25.36 |
| **Blood Pressure** | 0.72 | 28.45 |

### 3.2 Key Findings
- **Glucose is the strongest predictor of diabetes risk**, followed by BMI and Age.
- **Pregnancy history, insulin levels, and genetic predisposition** had moderate importance.
- **Skin Thickness and Blood Pressure had the least predictive power**.

### 3.3 Conclusion
- **Glucose monitoring, weight management, and addressing aging-related risks** are critical in diabetes prevention.
- **Lifestyle and metabolic factors play a more dominant role than genetics in predicting diabetes risk.**

---

## **Final Thoughts**
This analysis highlights the importance of multiple health indicators in predicting diabetes risk. While glucose levels, BMI, and age are strong predictors, a holistic approach considering lifestyle, metabolic health, and genetic factors is necessary for effective diabetes prevention and management.

### **Future Work**
- Improve prediction accuracy by tuning Random Forest hyperparameters.
- Compare performance with Gradient Boosting and XGBoost models.
- Analyze additional health markers for deeper insights.

---

### **Repository Structure**
```
📂 project-repo
 ├── 📄 README.md   # Overview of the analysis
 ├── 📊 dataset.csv  # Health dataset used in analysis
 ├── 📜 analysis.R   # R code for statistical modeling
 ├── 📊 figures/     # Visualization outputs
 └── 📄 report.pdf   # Full research report
```

**For questions or contributions, feel free to open an issue or submit a pull request!** 🚀

---
  title: "Your Document Title"
author: "Your Name"
date: "`r Sys.Date()`"
output: word_document
---
  

####install necessary packages####

#install.packages("ggplot2")
#install.packages("caret", dependencies = TRUE)
#install.packages("caret", repos="https://cloud.r-project.org/")
#install.packages("lava")
#install.packages("corrplot")
#install.packages("MASS")
#install.packages("randomForest")
#install.packages("stargazer")  # For regression result
#install.packages("knitr")      # For formatting tables
#install.packages("kableExtra") # For enhanced tables

#### Load necessary libraries ####
library(ggplot2)
library(dplyr)
library(lava)
library(caret)
library(corrplot)
library(MASS)
library(randomForest)
library(stargazer)
library(knitr)
library(kableExtra)

####Directory for data save####
setwd('F:/R Programming/project 3')
getwd()

# Load the dataset
df <- read.csv("diabetes.csv")

# Check for missing values
sum(is.na(df))

# Handling missing values: Replace 0 values in certain columns with NA (except Pregnancies and Diabetes)
cols_with_zeros <- c("Glucose", "BloodPressure", "SkinThickness", "Insulin", "BMI")
df[cols_with_zeros] <- lapply(df[cols_with_zeros], function(x) ifelse(x == 0, NA, x))

# Impute missing values with median
df[cols_with_zeros] <- lapply(df[cols_with_zeros], function(x) ifelse(is.na(x), median(x, na.rm = TRUE), x))

# Convert categorical variable
df$Diabetes <- as.factor(df$Diabetes)



#### Problem Statement 1: Blood Pressure and BMI (Using Linear Regression)####


# Scatter plot
ggplot(df, aes(x = BloodPressure, y = BMI)) +
  geom_point(alpha = 0.5, color = "blue") +
  geom_smooth(method = "lm", col = "red") +
  labs(title = "Relationship between Blood Pressure and BMI",
       x = "Blood Pressure (mm Hg)", y = "BMI") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) 

# Correlation
cor(df$BloodPressure, df$BMI, use = "complete.obs")

# Linear regression model
bp_bmi_model <- lm(BMI ~ BloodPressure, data = df)
summary(bp_bmi_model)


# Save regression summary as a CSV file
regression_results <- summary(bp_bmi_model)$coefficients
write.csv(regression_results, "linear_regression_results.csv", row.names = TRUE)

# Evaluate model performance
predicted_bmi <- predict(bp_bmi_model, df)
mse_bmi <- mean((df$BMI - predicted_bmi)^2)
cat("Mean Squared Error (BMI Model):", mse_bmi, "\n")

# Root Mean Squared Error (RMSE)
rmse_bmi <- sqrt(mse_bmi)
cat("Root Mean Squared Error (BMI Model):", rmse_bmi, "\n")




#### Problem Statement 2:How other variables are affecting a patient's glucose levels? 

# Compute the correlation matrix (excluding the categorical Diabetes column)
cor_matrix <- cor(df[, -ncol(df)], use = "complete.obs")

# Convert correlation matrix to a data frame for Excel export
cor_df <- as.data.frame(cor_matrix)
head(cor_df)

#write_xlsx(cor_df, "correlation_matrix.xlsx")


# Splitting data for training and testing
set.seed(123)
train_index <- createDataPartition(df$Glucose, p = 0.8, list = FALSE)
train_data <- df[train_index,]
test_data <- df[-train_index,]

# Random forest model to predict Glucose
rf_glucose <- randomForest(Glucose ~ . -Diabetes, data = train_data, importance = TRUE, ntree = 100)
print(rf_glucose)
summary(rf_glucose)

# Feature importance
importance <- importance(rf_glucose)
varImpPlot(rf_glucose)


# Extract variable importance
var_imp <- as.data.frame(importance(rf_glucose))
var_imp$Variable <- rownames(var_imp)

#install.packages("gridExtra")
library(gridExtra)  # For arranging multiple plots

# Create the first ggplot visualization for %IncMSE
p1 <- ggplot(var_imp, aes(x = reorder(Variable, `%IncMSE`), y = `%IncMSE`, fill = `%IncMSE`)) +
  geom_bar(stat = "identity", color = "black") +
  coord_flip() +  
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  theme_minimal() +
  labs(title = "Variable Importance in Predicting Glucose Levels",
       x = "Variables", y = "% Increase in MSE") +
  theme(text = element_text(size = 14),
        plot.title = element_text(hjust = 0.5, face = "bold"))

# Create the second ggplot visualization for IncNodePurity
p2 <- ggplot(var_imp, aes(x = reorder(Variable, IncNodePurity), y = IncNodePurity, fill = IncNodePurity)) +
  geom_bar(stat = "identity", color = "black") +
  coord_flip() +  
  scale_fill_gradient(low = "lightgreen", high = "darkgreen") +
  theme_minimal() +
  labs(title = "Variable Importance Based on IncNodePurity",
       x = "Variables", y = "Increase in Node Purity") +
  theme(text = element_text(size = 14),
        plot.title = element_text(hjust = 0.5, face = "bold"))

# Arrange the plots side by side
grid.arrange(p1, p2, ncol = 1)  # Use ncol=1 for stacking them vertically

# Model prediction and evaluation
predicted_glucose <- predict(rf_glucose, test_data)
mse_glucose <- mean((test_data$Glucose - predicted_glucose)^2)
cat("Mean Squared Error (Glucose Model):", mse_glucose, "\n")



#### Problem Statement 3: Key Variable for Diabetes Risk (Using Logistic Regression & Random Forest) ####

# Set seed for reproducibility
set.seed(123)

# Train a Random Forest model to predict Diabetes risk
rf_model <- randomForest(Diabetes ~ ., data = df, importance = TRUE, ntree = 500)

# Extract variable importance
var_importance3 <- as.data.frame(importance(rf_model))
var_importance3$Variable <- rownames(var_importance3)
#write.csv(var_importance3, "variable_importance.csv", row.names = TRUE)

# Print column names to check the correct importance measure
print(colnames(var_importance3))

# Choose the correct importance column: "MeanDecreaseAccuracy"
importance_column <- "MeanDecreaseAccuracy"

# Plot feature importance with enhanced design
ggplot(var_importance3, aes(x = reorder(Variable, .data[[importance_column]]), 
                            y = .data[[importance_column]], fill = .data[[importance_column]])) +
  geom_bar(stat = "identity", color = "black", width = 0.6) +  # Adjust bar width
  coord_flip() +
  scale_fill_gradient(low = "#87CEEB", high = "#00008B") +  # Skyblue to dark blue
  theme_minimal() +
  labs(title = "Top Predictors of Diabetes Risk",
       subtitle = "Feature Importance Measured by Mean Decrease in Accuracy",
       x = "Variables", y = "Mean Decrease in Accuracy") +
  theme(
    text = element_text(size = 14, family = "Arial"),
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray40"),
    axis.text = element_text(size = 12, color = "black"),
    axis.title = element_text(size = 14, face = "bold"),
    panel.grid.major.x = element_line(color = "gray90"),  # Subtle grid lines
    panel.grid.minor = element_blank(),
    legend.position = "right",
    legend.title = element_text(face = "bold")
  ) +
  geom_text(aes(label = round(.data[[importance_column]], 1)), 
            hjust = -0.2, size = 5, color = "black", fontface = "bold")  # Add value labels
# Save the plot as an png file 
#ggsave("diabetes_feature_importance.png", width = 16, height = 6, dpi = 300, device = "png")

# Identify the most important variable
most_important_variable <- var_importance3 %>%
  arrange(desc(.data[[importance_column]])) %>%
  slice(1)


# Print the most important variable
print(paste("The most important variable for predicting diabetes risk is:", most_important_variable$Variable))

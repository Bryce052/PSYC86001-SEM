# Read the data
data <- read.csv("JEdata_sheet1.csv")

# Display the first few rows of the data
head(data)

# Generate summary statistics for each variable in the data frame
summary(data)

# Examine data structure
str(data)

# Define the variables of interest
JE_variables <- c("JE1_p1", "JE2_p2", "JE3_p3", "JE4_p4", "JE5_p5", 
                  "JE6_p6", "JE7_e1", "JE8_e2", "JE9_e3", "JE10_e4", 
                  "JE11_e5", "JE12_e6", "JE13_c1", "JE14_c2", "JE15_c3", 
                  "JE16_c4", "JE17_c5", "JE18_c6")

# Extract a subset of the data containing only the specified variables
JE_subset <- data[, JE_variables]

# Compute the correlation matrix for the subset of variables
correlation_matrix <- cor(JE_subset)

# Calculate the standard deviation for each variable
standard_deviations <- apply(JE_subset, 2, sd)

# Combine the correlation matrix and standard deviations into a single data frame
result <- data.frame(Variable = names(standard_deviations), 
                     Standard_Deviation = standard_deviations,
                     Correlation = NA)  # Placeholder for correlation values

# Print the combined result, showing both standard deviations and the correlation matrix
print(result)
print(correlation_matrix)

# Model 1: Confirmatory Factor Analysis (CFA)

# Load necessary libraries
library(lavaan)

# Define the model: One single factor named 'JE' will load on all 18 items
model <- '
  JE =~ JE1_p1 + JE2_p2 + JE3_p3 + JE4_p4 + JE5_p5 + JE6_p6 +
        JE7_e1 + JE8_e2 + JE9_e3 + JE10_e4 + JE11_e5 + JE12_e6 +
        JE13_c1 + JE14_c2 + JE15_c3 + JE16_c4 + JE17_c5 + JE18_c6'

# Fit the model using the defined structure and the provided data
fit <- cfa(model, data = data)

# Print parameter estimates
parameterestimates(fit)  # Extracts parameter estimates from the fitted model object

# Summarize the fitted model, including parameter estimates, standard errors, test statistics, and p-values
summary(fit, rsquare = TRUE, standardized = TRUE, ci = TRUE)  # Ensures inclusion of R-squared, standardized estimates, and confidence intervals

# Model 2: Multi-Factor Model

# Define model 
# - Factor named 'Physical' will load on items JE1_p1, JE2_p2, JE3_p3, JE4_p4, JE5_p5, and JE6_p6
# - Factor named 'Emotional' will load on items JE7_e1, JE8_e2, JE9_e3, JE10_e4, JE11_e5, and JE12_e6
# - Factor named 'Cognitive' will load on items JE13_c1, JE14_c2, JE15_c3, JE16_c4, JE17_c5, and JE18_c6

# Define the model
model_2 <- '
  # Define latent factors and their loadings
  Physical =~ JE1_p1 + JE2_p2 + JE3_p3 + JE4_p4 + JE5_p5 + JE6_p6
  Emotional =~ JE7_e1 + JE8_e2 + JE9_e3 + JE10_e4 + JE11_e5 + JE12_e6
  Cognitive =~ JE13_c1 + JE14_c2 + JE15_c3 + JE16_c4 + JE17_c5 + JE18_c6
 '

# Fit the model
fit_2 <- cfa(model_2, data = data)

# Print parameter estimates
parameterestimates(fit_2)  # Extracts parameter estimates from the fitted model object

# Summarize the fitted model, including parameter estimates, standard errors, test statistics, and p-values
summary(fit_2, rsquare = TRUE, standardized = TRUE, ci = TRUE)  # Ensures inclusion of R-squared, standardized estimates, and confidence intervals

# Comparison of Models 1 and 2 using various metrics of model fit 
fitmeasures(fit)
fitmeasures(fit_2)

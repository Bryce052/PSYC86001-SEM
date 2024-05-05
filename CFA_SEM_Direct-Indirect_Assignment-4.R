# Read the CSV file
data <- read.csv("RuminationData.csv")

# Display the first few rows of the data
head(data)

# Generate summary statistics for each variable in the data frame
summary(data)

# Examine data structure
str(data)

# Define the variables of interest
Rumination_variables <- c("rumi1", "rumi2", "rumi3", "rumi4", "sleep1", 
                          "sleep2", "sleep3", "sad1", "sad2", "sad3", 
                          "sad4", "leukocyt", "lymphocy")

# Extract a subset of the data containing only the specified variables
Rumination_subset <- data[, Rumination_variables]

# Compute the correlation matrix for the subset of variables
correlation_matrix <- cor(Rumination_subset)

# Calculate the standard deviation for each variable
standard_deviations <- apply(Rumination_subset, 2, sd)

# Combine the correlation matrix and standard deviations into a single data frame
result <- data.frame(Variable = names(standard_deviations), 
                     Standard_Deviation = standard_deviations,
                     Correlation = NA)  # Placeholder for correlation values

# Print the combined result, showing both standard deviations and the correlation matrix
cat("\nStandard Deviations:\n")
print(result)
cat("\nCorrelation Matrix:\n")
print(correlation_matrix)

# Model 1 - CFA 

# Load required library
library(lavaan)

# Define the CFA model
cfa_model <- '
  # Define latent factors
  rumination =~ rumi1 + rumi2 + rumi3 + rumi4
  sadness =~ sad1 + sad2 + sad3 + sad4
  sleep =~ sleep1 + sleep2 + sleep3
  immunity =~ leukocyt + lymphocy

  # Define interrelations between factors
  rumination ~~ sadness
  rumination ~~ sleep
  rumination ~~ immunity
  sadness ~~ sleep
  sadness ~~ immunity
  sleep ~~ immunity
'

# Fit the CFA model to the data
cfa_fit <- lavaan::cfa(cfa_model, data = data)

# Summarize the model results including parameters, standardized parameters, fit measures, CI, and R-square
summary(cfa_fit, standardize = TRUE, fit.measures = TRUE, ci = TRUE, rsquare = TRUE)

# Create the path diagram for the CFA model
# Load required libraries
library(semPlot)

semPaths(cfa_fit, layout = "tree2", whatLabels = "std", style = "lisrel", edge.label.cex = 0.8)

# Model 2 - Structural Equation Modeling (SEM)
# Define the SEM Model

# model 2 
# Load required library
library(lavaan)

# Define the SEM model
sem_model <- '
  # Define latent factors (using the same variables as in the CFA)
  rumination =~ rumi1 + rumi2 + rumi3 + rumi4
  sadness =~ sad1 + sad2 + sad3 + sad4
  sleep =~ sleep1 + sleep2 + sleep3
  immunity =~ leukocyt + lymphocy
  
  # Structural paths
  # Define additional relationships between latent factors
  sleep ~ a * rumination    # Direct effect of Rumination on Sleep
  sadness ~ b * rumination  # Direct effect of Rumination on Sadness
  immunity ~ c * sleep      # Direct effect of Sleep on Immunity
  immunity ~ d * sadness    # Direct effect of Sadness on Immunity
'

# Fit the SEM model to the data
sem_fit <- sem(sem_model, data = data, sample.nobs = 300)

# Summarize the results
summary(sem_fit, standardize = TRUE, rsquare = TRUE, ci = TRUE)
semPaths(sem_fit, layout = "tree2", whatLabels = "std", style = "lisrel", edge.label.cex = 0.8)

# Define the SEM model with mediation pathway
sem_model_2 <- '
  # Define latent factors (using the same variables as in the CFA and SEM Model 1)
  rumination =~ rumi1 + rumi2 + rumi3 + rumi4
  sadness =~ sad1 + sad2 + sad3 + sad4
  sleep =~ sleep1 + sleep2 + sleep3
  immunity =~ leukocyt + lymphocy
  
  # Structural paths including indirect effects
  # Define additional relationships between latent factors including the mediation pathway
  sleep ~ a * rumination    # Direct effect of Rumination on Sleep
  sadness ~ b * rumination  # Direct effect of Rumination on Sadness
  immunity ~ c * sleep      # Direct effect of Sleep on Immunity
  immunity ~ d * sadness    # Direct effect of Sadness on Immunity
  
  # Define indirect effects
  ind1 := a * b             # Indirect effect of Rumination on Immunity through Sleep
  ind2 := c * d             # Indirect effect of Sadness on Immunity through Sleep
'

# Fit the SEM model to the data
sem_fit_2 <- sem(sem_model_2, data = data, sample.nobs = 300)

# Summarize the results
summary(sem_fit_2, standardize = TRUE, rsquare = TRUE, ci = TRUE)

# Plot the SEM path diagram
semPaths(sem_fit_2, layout = "tree2", whatLabels = "std", style = "lisrel", edge.label.cex = 0.8)


# Compare the fit of the models using various measures
cfa_fit_measures <- fitMeasures(cfa_fit)
sem_fit_measures <- fitMeasures(sem_fit)

# Print fit measures for CFA model 
print("Fit measures for CFA model:")
print(cfa_fit_measures)

# print fit measures for SEM model
print("Fit measures for SEM model:")
print(sem_fit_measures)

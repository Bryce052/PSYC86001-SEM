# Load required packages
library(readxl)
library(dplyr)
library(modeest)
library(knitr)
library(kableExtra)
library(lavaan)
library(semPlot)

# Load the Excel file
file_path <- "Milwaukee_Neighborhoods_Spatial_Join_Data.xlsx" 
data <- read_excel(file_path)

# Display the first few rows of the data frame
head(data)

# Generate summary statistics for each variable in the data frame
summary(data)

# Examine data structure
str(data)

# Calculate measures of central tendency and dispersion for all variables
calculate_measures <- function(df) {
  measures <- df %>%
    summarise_all(list(
      Mean = ~ mean(.),
      Median = ~ median(.),
      Mode = ~ mfv(.),
      Std_Dev = ~ sd(.),
      Variance = ~ var(.)
    ))
  
  measures <- measures %>%
    pivot_longer(cols = everything(), names_to = c("Variable", ".value"), names_sep = "_")
  
  return(measures)
}

measures <- calculate_measures(data)

# Display the measures in a table
measures %>%
  kable("html", caption = "Measures of Central Tendency and Dispersion") %>%
  kable_styling(full_width = FALSE, position = "center", bootstrap_options = c("striped", "hover", "condensed"))

# Define the variables of interest
Environmental_Attractiveness <- c("MPD_Stations", "Robberies", "Burglaries", "Establishments", "Ambient_Population", 
                                  "CCTVs", "Census_Population", "Median_Household_Income","Street_Accessibility", "Street_Choice")

# Extract a subset of the data containing only the specified variables
Variable_subset <- data[, Environmental_Attractiveness]

# Compute the correlation matrix for the subset of variables
correlation_matrix <- cor(Variable_subset)

# Model 1 - CFA 

# Define the CFA model
cfa_model <- '
  crime_opportunities =~ Robberies + Establishments + Ambient_Population + Median_Household_Income
  deterrence =~ MPD_Stations + CCTVs + Street_Choice
  environmental_attractiveness_for_crime =~ deterrence + crime_opportunities
  
  deterrence ~~ crime_opportunities 
'

# Fit the CFA model to the data
cfa_fit <- lavaan::cfa(cfa_model, data = data)

# Summarize the model results including parameters, standardized parameters, fit measures, CI, and R-square
summary(cfa_fit, standardize = TRUE, fit.measures = TRUE, ci = TRUE, rsquare = TRUE)

# Create the path diagram for the CFA model
semPaths(cfa_fit, layout = "tree2", whatLabels = "std", style = "lisrel", edge.label.cex = 0.8)

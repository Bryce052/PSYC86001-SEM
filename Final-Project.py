# Descriptive Statistics

# Import libraries
import pandas as pd 
import os

# Specify the path to the desired working directory
new_working_directory = '/users/Bryce/Downloads'

# Change the working directory
os.chdir(new_working_directory)

# Verify the change
print("Current working directory:", os.getcwd())

# Load excel file into dataframe 
df = pd.read_excel('Milwaukee_Neighborhoods_Spatial_Join_Data.xlsx')
print("First few rows of the dataframe") 
print(df.head())

# Calculate measures of central tendency
mean = df.mean()
median = df. median()
mode = df.mode().iloc[0] # Take first mode if variable has multiple mode values

# Calculate measures of dispersion 
std_dev = df.std()
variance = df.var()
rang_val = df.max() - df.min() 

# Display the calculated statistics
print("\nMeasures of Central Tendency:") 
print("Mean:\n", mean) 
print("\nMedian:\n", median)
print("\nMode:\n", mode) 

print("\nMeasures of Dispersion:")
print("Standard Deviation:\n", std_dev)
print("\nVariance:\n", variance) 
print("\nRange:\n", range_val) 

# Creation of Tables for Descriptive Measurements
import pandas as pd
from tabulate import tabulate

# Data for Measures of Central Tendency
central_tendency_data = {
    'Measure': ['Mean', 'Median', 'Mode'],
    'Neighborhood_FID': [95.5, 95.5, 1.0],
    'Area': [2468727.0, 1873907.0, 71702.136719],
    'MPD_Stations': [0.1473684, 0.0, 0.0],
    'Robberies': [246.7737, 72.5, 1.0],
    'Burglaries': [123.3868, 36.25, 0.5],
    'Establishments': [10.03684, 5.0, 1.0],
    'Ambient_Population': [4557.366, 4063.0, 1840.0],
    'CCTVs': [76.17368, 75.5, 71.0],
    'Census_Population': [5073.226, 3249.667, 1226.666667],
    'Median_Household_Income': [46644.85, 48453.5, 20120.0],
    'Street_Accessibility': [135.8368, 135.5, 88.0],
    'Street_Choice': [70.51579, 68.5, 42.0]
}

# Data for Measures of Dispersion
dispersion_data = {
    'Measure': ['Standard Deviation', 'Variance'],
    'Neighborhood_FID': [54.99242, 3024.167],
    'Area': [2149499.0, 4.620344e+12],
    'MPD_Stations': [0.369997, 0.1368978],
    'Robberies': [363.5705, 132183.5],
    'Burglaries': [181.7852, 33045.87],
    'Establishments': [18.66224, 348.2791],
    'Ambient_Population': [2787.743, 7771510.0],
    'CCTVs': [14.89882, 221.975],
    'Census_Population': [6773.324, 45877920.0],
    'Median_Household_Income': [15044.87, 2.263481e+08],
    'Street_Accessibility': [39.22085, 1538.275],
    'Street_Choice': [17.08049, 291.7431]
}

# Creating DataFrames
central_tendency_df = pd.DataFrame(central_tendency_data)
dispersion_df = pd.DataFrame(dispersion_data)

# Displaying the tables
print("Measures of Central Tendency:")
print(tabulate(central_tendency_df, headers='keys', tablefmt='fancy_grid'))

print("\nMeasures of Dispersion:")
print(tabulate(dispersion_df, headers='keys', tablefmt='fancy_grid'))

# Model 1 - CFA
import pandas as pd
import numpy as np
from semopy import Model, Optimizer
from semopy.inspector import inspect

# Load the Excel file
file_path = "Milwaukee_Neighborhoods_Spatial_Join_Data.xlsx"
data = pd.read_excel(file_path)

# Display the first few rows of the data frame
print(data.head())

# Generate summary statistics for each variable in the data frame
print(data.describe())

# Examine data structure
print(data.info())

# Define the variables of interest
Environmental_Attractiveness = ["MPD_Stations", "Robberies", "Burglaries", "Establishments", "Ambient_Population", 
                                "CCTVs", "Census_Population", "Median_Household_Income", "Street_Accessibility", "Street_Choice"]

# Extract a subset of the data containing only the specified variables
Variable_subset = data[Environmental_Attractiveness]

# Compute the correlation matrix for the subset of variables
correlation_matrix = Variable_subset.corr()
print(correlation_matrix)

# Define the CFA model
cfa_model = '''
crime_opportunities =~ Robberies + Establishments + Ambient_Population + Median_Household_Income
deterrence =~ MPD_Stations + CCTVs + Street_Choice
environmental_attractiveness_for_crime =~ deterrence + crime_opportunities

deterrence ~~ crime_opportunities
'''

# Fit the CFA model to the data
model = Model(cfa_model)
opt = Optimizer(model)
opt.fit(data)

# Summarize the model results
summary = inspect(opt, model)
print(summary)

# Create the path diagram for the CFA model

import networkx as nx
import matplotlib.pyplot as plt

# Generate the graph representation
graph = model.graph()

# Plot the graph
pos = nx.spring_layout(graph)
plt.figure(figsize=(10, 8))
nx.draw(graph, pos, with_labels=True, node_color="lightblue", edge_color="gray", node_size=5000, font_size=10, font_weight="bold")
plt.title('Path Diagram for CFA Model')
plt.show()

# Initial Concentric Zone Model 
import matplotlib.pyplot as plt

# Define the number of zones and their labels
zones = 5
labels = ["Central Business District", "Zone of Transition", "Working Class Zone", "Residential Zone", "Commuter Zone"]

# Define the radii for each zone
radii = [1, 2, 3, 4, 5]

# Define the colors for each zone
colors = ['#70587C', '#92A8D1', '#034F84', '#B565A7', '#FF6F61']

# Create a figure and axis
fig, ax = plt.subplots(figsize=(8, 8))

# Create the concentric circles
for i in range(zones):
    circle = plt.Circle((0, 0), radii[i], color=colors[i], ec='black', alpha=0.5)
    ax.add_artist(circle)
    
    # Add the label for each zone
    label_radius = (radii[i] + (radii[i-1] if i > 0 else 0)) / 2
    if labels[i] == "Commuter Zone":
        ax.text(0, label_radius + 0.2, labels[i], ha='center', va='center', fontsize=10, fontweight='bold', bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.3'))
    elif labels[i] == "Central Business District":
        ax.text(0, 0, labels[i], ha='center', va='center', fontsize=10, fontweight='bold', bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.3'))
    else:
        ax.text(label_radius, 0, labels[i], ha='center', va='center', fontsize=10, fontweight='bold', bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.3'))

# Set the limits and aspect ratio
ax.set_xlim(-radii[-1]-1, radii[-1]+1)
ax.set_ylim(-radii[-1]-1, radii[-1]+1)
ax.set_aspect('equal')

# Remove axes
ax.axis('off')

# Add a title
plt.title('Concentric Zone Model', fontsize=16, fontweight='bold')

# Show the plot
plt.show()

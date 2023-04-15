library(tidyverse)
library(readxl)
library(broom)
library(modelr)
library(rsample)

# Read in the csv file as a dataframe
questionposts <- read.csv("questionposts.csv")

# Read in the second dataframe
questions <- read.csv("questions.csv")

# Join the two dataframes by the common column "QuestionUNO"
merged_df <- merge(questionposts, questions, by = "QuestionUNO")

# Print the merged dataframe
glimpse(merged_df)
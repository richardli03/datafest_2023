library(tidyverse)
library(readxl)
library(broom)
library(modelr)
library(rsample)
library(dplyr) # for data wrangling
library(tidytext) # for NLP
library(stringr) # to deal with strings
library(wordcloud) # to render wordclouds
library(knitr) # for tables
library(DT) # for dynamic tables
library(tidyr)

# Read in the csv file as a dataframe
questionposts <- read.csv("~/Olin/Data Science/datafest_2023/data/questionposts.csv")

# Read in the second dataframe
questions <- read.csv("~/Olin/Data Science/datafest_2023/data/questions.csv")

clients <- read.csv("~/Olin/Data Science/datafest_2023/data/clients.csv")

attorneys <- read.csv("~/Olin/Data Science/datafest_2023/data/attorneys.csv")

# Join the two dataframes by the common column "QuestionUNO"
mega_df <- left_join(questionposts, questions, by = "QuestionUno") %>% 
  left_join(clients, by = c("AskedByClientUno" = "ClientUno")) %>% 
  left_join(attorneys, by = c("TakenByAttorneyUno" = "AttorneyUno")) %>% 
  select(c("StateAbbr.x", "QuestionUno", "PostText", "CreatedUtc.x", "Category",
           "Subcategory", "AskedByClientUno", "AskedOnUtc", 
           "TakenByAttorneyUno", "TakenOnUtc", "ClosedByAttorneyUno", 
           "ClosedOnUtc", "LegalDeadline", "County.x", "EthnicIdentity", "Age",
           "Gender", "MaritalStatus", "Veteran", "Imprisoned", 
           "NumberInHousehold", "AnnualIncome", "AllowedIncome", 
           "CheckingBalance", "SavingsBalance", "InvestmentsBalance")) %>% 
  rename("StateAbbr" = "StateAbbr.x", "County" = "County.x", 
         "CreatedUtc" = "CreatedUtc.x")

cleaned_df <- mega_df %>% 
  filter(nchar(StateAbbr) == 2)

posts <- cleaned_df %>% 
  select("PostText", "QuestionUno") 

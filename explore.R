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
library(tidyr)
library(data.table)

# Read in the csv file as a dataframe
questionposts <- read.csv("./data/questionposts.csv")

# Read in the second dataframe
questions <- read.csv("./data/questions.csv")

clients <- read.csv("./data/clients.csv")

attorneys <- read.csv("./data/attorneys.csv")

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
  filter(Category == "Work, Employment and Unemployment") %>% 
  select("PostText", "QuestionUno") 

words <- posts %>% 
  unnest_tokens("word", "PostText") %>% 
  dplyr::count(word, sort = TRUE) %>% 
  ungroup()

data("stop_words")
words_clean <- words %>%
  anti_join(stop_words)

words_clean %>% head(10)

words_clean %>% 
  with(wordcloud(word, n, random.order = FALSE, max.words = 50))

cleaned_df %>% 
  filter(StateAbbr == "VI") %>% 
  glimpse()

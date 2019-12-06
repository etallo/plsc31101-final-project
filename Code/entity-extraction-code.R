## ENTITY EXTRACTION CODE ##

# This code does the following:
# 1. Loads the csv files of the named entities (states and union territories of India, terrorist organizations that are active in India,
#    and districts in the most terror-afflicted state in India (Jammu and Kashmir) that I am interested in.
# 2. Preprocesses the text to correct/account for common spellings of words that appear in names of places and terrorist organizations 
#    (i.e. mojahideen vs. mujahideen). 
# 3. It also makes both the lists of named entities and the incident descriptions lowercase. If left unprocessed, 
#    the chances of extracting the named entities would be reduced. 
# 4. Creates a function to extract the named entities. 
# 5. Maps the function over each of the lists, combines the results into a dataframe, and writes the dataframe to a csv file. 

## SET UP ##

library(tidyverse)
library(rvest)
library(lubridate)
library(stringr)
library(purrr)
library(tm)

setwd("/Users/emilytallo/Dropbox/Chicago/Fall 2019/Computational-Tools/Final-Project/Data")
scraped_df <- read.csv("scraped-satp-india-incidents.csv", stringsAsFactors = F)
colnames(scraped_df) <- c("uid", "date", "incident")

#Below are lists of named entities that I am checking for 

#States and Union Territories of India 
states <- read.csv("list-of-states.csv", stringsAsFactors = F, header = F, encoding = "UTF-8")
state <- as.vector(states[,1])
final_state <- as.vector(states[,2])
state = tolower(state)
final_state = tolower(final_state)

#Terrorist organizations that are/have been active in India since 2000
terroristorgs <- read.csv("named-terrorist-orgs.csv", stringsAsFactors = F, encoding = "UTF-8") 
org <- as.vector(terroristorgs$org)
final_org <- as.vector(terroristorgs$final_org)
org = tolower(org)
final_org = tolower(final_org)

#Districts in the Indian state of Jammu and Kashmir
JKdistricts <- read.csv("list-of-jk-districts.csv", stringsAsFactors = F, header = F, encoding = "UTF-8") 
JKdistrict <- as.vector(JKdistricts[,1])
final_JKdistrict <- as.vector(JKdistricts[,2])
JKdistrict = tolower(JKdistrict)
final_JKdistrict = tolower(final_JKdistrict)

## TEXT PREPROCESSING ##

#The below function accounts for various ways of spelling common words, especially terrorist organizations, 
#in the named entity lists, to decrease NAs & increase the likelihood of matching with the named entities 

preprocess_text <- function(an_incident){
  processed_incident <- an_incident %>%
    str_replace_all("-", " ") %>%
    str_replace_all("Mojahedin", "Mujahideen") %>%
    str_replace_all("Mujahedin", "Mujahideen") %>%
    str_replace_all("Harakat", "Harkat") %>%
    str_replace_all("Jehad", "Jihad") %>% 
    str_replace_all("Jehadi", "Jihadi") %>%
    str_replace_all("Tehreek", "Tehrik") 
  return(processed_incident)                 
}

#Map to all incidents in the incident column of our dataframe 
processed_incident_col <- map(scraped_df$incident, preprocess_text) %>%
  unlist()

#We want to pick up string matches regardless of capitalization, so we need to lower the text 
#in the processed incident column
processed_incident_col = tolower(processed_incident_col)

## EXTRACTING NAMED ENTITIES FROM PREPROCESSED TEXT ##

# Combined, the next two functions do the following:
#1. For each of the elements in the vector of named entities, check to see if they appear in 
#   a given text. 
#2. Then, if an element appears, return the element of the same index in the final_entities vector.
#3. If the character vector is empty after that, print NA. 
#(Note that exists_in_string is called in the extract_string function, and is separated here only for simplicity.)

exists_in_string <- function(s1, s2){
  return(grepl(s1, s2))
}

extract_string <- function(text, entities, final_entities) {
  for (i in seq_along(1:length(entities))) {
    if(exists_in_string(entities[i], text)) {
      return(final_entities[i])
    }
  }
  return(NA)
}

#Map the function onto the incident text for each of the desired entity lists

#To extract states named in incident text
state_col <- map(processed_incident_col, extract_string, state, final_state) %>%
  unlist() 

#To extract terrorist organizations named in incident text
attr_org_col <- map(processed_incident_col, extract_string, org, final_org) %>%
  unlist()

#To extract districts named in incident text
district_col <- map(processed_incident_col, extract_string, JKdistrict, final_JKdistrict) %>%
  unlist()

#Create dataframe with all 6 variables 
df <- data.frame(scraped_df$uid, scraped_df$date, processed_incident_col, district_col, state_col, 
                 attr_org_col, stringsAsFactors = F)
colnames(df) <- c("uid", "date", "incident text", "district", "state", "attributed organizations")

#fill in the state column for the Jammu and Kashmir districts  
df$state[which(!is.na(df$district))] <- "jammu and kashmir"

#Write CSV file 
write.csv(df, file = "processed-satp-india-incidents.csv")

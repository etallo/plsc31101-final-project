
## WEBSCRAPING CODE ##

#This code does the following:
# 1. Creates a list of the urls of interest. These urls contain dates and descriptions of terrorist incidents that happened 
#    in a particular year. 
# 2. Creates a condense function to clean up the text describing each incident. 
# 3. Creates a parse_url function (which calls the condense function) that parses and extracts cleanly 
#    formatted dates and incident descriptions.
# 4. Maps the parse_url function over the urls of interest, puts the extracted information into a dataframe, and 
#    writes the dataframe. 

## SET UP ##

library(tidyverse)
library(rvest)
library(lubridate)
library(stringr)
library(purrr)

setwd("~/Dropbox/Chicago/Fall 2019/Computational-Tools/Final-Project/Data")

#This for loop will create a list of urls from 2000 and 2018 
urlyears <- c(2000:2018)
output <- vector(mode = "character", length(urlyears))  # 1. Create an empty vector of 19 years
for (i in seq_along(urlyears)) { # 2. Iterate over each of the values in the "urlyears" vector we created 
  output[i] <- str_c("https://www.satp.org/other-data/india/major-incidents_", 
                     as.character(urlyears[i])) # 3. #Concatenate the string and the years of each url 
}
list_urls <-output

## WEBSCRAPING ##

#The condense function condenses our incident text and removes duplication of text
condense <- function(full_incident) {
  part1 <- str_split(full_incident, "(?<=Read more\\.\\.\\.)")[[1]]
  part2 <- tail(part1, 1)
  part3 <- str_remove(part2, "Read less\\.\\.\\.")
  part4 <- str_replace_all(part3, "[\\r\\n]", "")
  final_text <- trimws(part4)
  return(final_text)
}

#The parse_url function parses/condenses the data and incident info from a given url
parse_url <- function(input_url){
doc <- read_html(input_url)

#create year variable for page  
year <- html_nodes(doc, "h1") %>%
  html_text() %>%
  str_extract("[0-9]+")

#create date column
date <- html_nodes(doc, "td:nth-child(1)") %>%
  html_text(trim=T) %>%
  str_replace_all("\\ - ", ",") %>%
  str_extract_all(".+(?=\\&nbsp)") %>%
  unlist() %>%
  paste(",") %>%
  paste(year) %>%
  mdy()

#create incident column
incident <- html_nodes(doc, "td:nth-child(2)") %>%
  html_text(trim=T) 

#remove rows that do not contain incident info
incident <- incident[grep("Read more\\.\\.\\.", incident)]

#create dataframe with date and incident
df <- data.frame(date, incident, stringsAsFactors = FALSE)
names(df) <- c("date", "incident")

#map condense function (which condenses text and trims whitespace) over all the incidents
df$incident <- map_chr(df$incident, condense) 

#return a dataframe of date and incident info for the URL
return(df)
}

#test the code
test <- parse_url(list_urls[1])
head(test$incident)

#map the parse_url function over our list of urls from the for-loop
all_df <- map(list_urls, parse_url) 

#create and writes df
main_df <- all_df[[1]]
for (i in seq_along(all_df[2:length(all_df)])) { 
  main_df <- full_join(main_df, all_df[[i]])
}
write.csv(main_df, "scraped-satp-india-incidents.csv")



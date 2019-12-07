## VISUALIZATION CODE ##

# This code does the following:
# 1. Visualizes the incident counts of my data by year in a bar graph
# 2. Visualizes the top 10 most terrorism afflicted states in a bar graph
# 3. Visualizes the top 10 most attributed terrorist organizations in a bar graph

library(tidyverse)
library(stringr)
library(purrr)
library(lubridate)

setwd("~/Dropbox/Chicago/Fall 2019/Computational-Tools/Final-Project/Data")
df <- read.csv("processed-satp-india-incidents.csv", stringsAsFactors = F)
df = df[-1]


#Plot of event counts per year
annual_df <- df %>%
  mutate(year = epiyear(date)) %>%
  count(year)

plot1<- ggplot(data = annual_df, aes(x = year, y = n)) +
  geom_bar(stat = "identity", fill = "darkorange1") +
  ylab("Number of incidents") +
  xlab("Year") + 
  ggtitle("Number of Terrorist Incidents in India by Year, 2000-2018")

print(plot1)

#Plot of overall top 10 event counts by state 

state_df <- df %>%
  count(state) %>%
  arrange(desc(n)) %>%
  head(11)

#get rid of NAs
state_df <- state_df[-2,]

plot2 <- ggplot(data = state_df, aes(x=reorder(state,n), y=n)) +
  geom_bar(stat = "identity", fill = "darkorange1") +
  xlab("State") +
  ylab("Number of Incidents") +
  ggtitle("Top 10 Most Terrorism-Afflicted States in India, 2000-2018") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(plot2)

#Plot of overall top 10 event counts by organization

org_df <- df %>%
  count(attributed.organizations) %>%
  arrange(desc(n)) %>%
  head(10) 

#get rid of NAs
org_df <- org_df[-1,]

plot3 <- ggplot(data = org_df, aes(x=reorder(attributed.organizations,n), y = n)) +
  geom_bar(stat = "identity", fill = "darkorange1") +
  xlab("State") +
  ylab("Number of Incidents") +
  ggtitle("Top 10 Most Attributed Terrorist Organizations, 2000-2018") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

print(plot3)  

ggsave(filename="incidents-by-year.jpeg", plot=plot1)
ggsave(filename="most-terrorism-states.jpeg", plot=plot2)
ggsave(filename="most-attributed-orgs.jpeg", plot=plot3)

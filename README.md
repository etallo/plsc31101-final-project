## Short Description

The goal of this project to webscrape terrorist incident and date data from roughly 19 tables located on the South Asia Terrorism Portal (SATP); extract the locations, dates, and terrorist organizations named in the incidents; and visualize the data gathered.   

## Dependencies

1. R, 3.6.1
2. R Studio, Version 1.2.5001

Packages: tidyverse, rvest, lubridate, stringr, purrr, tm

## Files

#### /

1. Narrative final project.Rmd: Provides a 5 page narrative of the project, its main challenges, and visualizations. 
2. Narrative-final-project.pdf: A knitted pdf of Narrative final project.Rmd. 
3. Slides.pptx: My lightning talk slides. 

#### Code/
1. webscrape-code.R: Scrapes and cleans date/incident data from 19 tables on the South Asia Terrorism Portal. The scraped dataframe from this file can be found in the Data directory. 
2. entity-extraction-code.R: Extracts Indian districts, states, and terrorist organizations named in scraped incident text and writes a .csv file containing the named entity data. The processed dataframe can be found in the Data directory. 
3. visualization-code.R: Conducts descriptive analysis of the data, producing the visualizations found in the Results directory.

#### Data/

1. scraped-satp-india-incidents.csv: Contains dataframe of major terrorist incidents in India and corresponding dates. The data were scraped from the 2000-2018 tables available at the South Asia Terrorism Portal (starting with this link): https://www.satp.org/other-data/india/major-incidents_2000 
2. processed-satp-india-incidents.csv: Contains dataframe of major terrorist incidents, corresponding dates, and the states, districts, and terrorist organizations named in the text of the major terrorist incidents.  
3. list-of-jk-districts.csv: Contains list used to extract the named districts of the disputed Indian state of Jammu and Kashmir. Compiled from Wikipedia and personal knowledge. 
4. list-of-states.csv: Contains list used to extract named Indian states within the incident. Compiled from Wikipedia. 
5. named-terrorist-orgs.csv: Contains list used to extract named terrorist organizations within the incident data. Compiled from Wikipedia and personal knowledge. 

#### Results/

1. incidents-by-year.jpeg: Plot of incident counts by year. 
2. most-attributed-orgs.jpeg: Plot of the top 10 most named terrorist organizations. 
3. most-terrorism-states.jpeg: Plot of the top 10 most named states in India.  

## More Information

This project is part of a larger, co-authored academic endeavor. My contact information is tallo@uchicago.edu if you have any questions. 

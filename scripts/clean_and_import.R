# Purpose: Load, clean and explore data related to bike theft in Toronto 
# Author: Shae-Linn Davies
# Email: s.davies@mail.utoronto.ca
# Date: 6 February 2022
# Prerequisites: Must access opendatatoronto to first load data.
# Notes: The following disclaimer is not included on the opendatatoronto site, however, the specific dataset "Bicycle Thefts" (Gelfand 2020) is also accessible through the Toronto Police Service Public Safety Data Portal, where it is included: "The reported crime dataset is intended to provide communities with information regarding public safety and awareness. The data supplied to the Toronto Police Service by the reporting parties is preliminary and may not have been fully verified" (Toronto Police Service 2022). 

#### Workspace set-up: installations ####

#Install packages
install.packages("opendatatoronto")
install.packages("knitr")
install.packages("janitor")
install.packages("lubridate")
install.packages("tidyverse")
install.packages("tidyr")
install.packages("dplyr")
install.packages("kableExtra")
install.packages("bookdown")

#### Acquire raw data ####

# #Based on: https://open.toronto.ca/dataset/bicycle-thefts/ 

# Datasets from opendatatoronto are formatted into packages with unique IDs.
# Get the metadata for the "Bicycle Thefts" portal package
 package <- show_package("c7d34d9b-23d2-44fe-8b3b-cd82c8b38978")

# Get all resources for this package, from the opendatatoronto portal.
 resources <- list_package_resources("c7d34d9b-23d2-44fe-8b3b-cd82c8b38978")

# Identify the datastore resource format; "by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources" (Gelfand 2020)
 datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# The datastore resource is loaded 
 data <- filter(datastore_resources, row_number()==1) %>% get_resource()


# Write the dataset to a new csv file so it can still be accessed in the event the original source is moved or changed. Commented out after written once for efficiency. 
 write_csv(
   x = data,
   file = "raw_thefts.csv"
   )

#Read in the new csv file 
raw_thefts <- 
  read_csv(file = "raw_thefts.csv",
           show_col_types = FALSE)

#### Clean the raw data ####

cleaned_thefts <-  
  clean_names(raw_thefts) |>
  select(occurrence_date,
         report_date,
         report_year,
         neighbourhood_name, # Additional neighbourhood_name column kept so that a cleaner dataset can further explored at a later time
         premises_type,
         status) |>
  filter(report_year %in% 2014:2020) #to ensure there are no entries leftover from previous years 

#### Save the cleaned dataset ####

# Save data by writing to a new csv file
write_csv(
  x = cleaned_thefts,
  file = "cleaned_thefts.csv"
)

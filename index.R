################################################################################
# Datasets for Data Story 4: Sewanee utilities & weather
################################################################################

# ******************************************************************************
# Ensure "sewanee_weather.rds" & "utilities.rds" are in your working directory
# ******************************************************************************

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(dplyr)
library(ggplot2)
library(readr)

rm(list = ls()) # clear environment first
dir() # look at files in your working directory

# weather ======================================================================
load('sewanee_weather.rds') # loads 3 datasets

# dataset #1: Monthly rainfall in Sewanee, 1895 - 2023
sewanee_rain %>% head
sewanee_rain %>% tail

# dataset #2: Monthly temperature in Sewanee, 1958 - 2023
# Note some years have wonky data
sewanee_temp$year %>% unique
# So let's take those rows out
sewanee_temp <- sewanee_temp %>% filter(!is.na(as.numeric(year)))
# Now take a look
sewanee_temp %>% head
sewanee_temp %>% tail

# dataset #3: Hourly weather (air temp, soil temp, humidity, rain) from Split Creek Observatory
# Aug 18, 2018 - June 14 2022
split_creek %>% head
split_creek %>% tail

# utilities  ===================================================================
load('utilities.rds') # loads two datasets

# dataset #1: Utilities data for every campus building (water, electricity, natural gas)
# caution: many rows have missing data
utilities %>% as.data.frame %>% head
utilities %>% as.data.frame %>% tail

# dataset #2: Same data for Fall 2025, but with residence hall occupancy information added
# broken down by gender
# caution again: many rows have missing data
fall2025 %>% as.data.frame %>% head
fall2025 %>% as.data.frame %>% tail



utility <- utilities %>% mutate(gal_person=gallons/capacity,
                                kwh_person=kwh/capacity,
                                therms_person=therms/capacity) %>%
  filter(type=="Residential - Residence Hall") %>%
  group_by(building, month) %>%
  summarize(gal_person= mean(gal_person,na.rm = TRUE),
            kwh_person= mean(kwh_person,na.rm = TRUE),
            therms_person= mean(therms_person,na.rm = TRUE))

ggplot(utility,
       aes(x = month,
           y = gal_person,
           group = building)) +
  geom_line()

getwd()

install.packages("tidyverse")
install.packages("dplyr")
install.packages("tidyr")
library(tidyverse)
library(dplyr)
library(stringr)
library(tidyr)

Storm_1991 <- read.csv(file = 'StormEvents_details-ftp_v1.0_d1991_c20220425.csv')
summary(Storm_1991)

limit_df <- c("BEGIN_DATE_TIME", "END_DATE_TIME", "EPISODE_ID", "EVENT_ID", "STATE", "STATE_FIPS", "CZ_NAME", "CZ_TYPE", "CZ_FIPS", "EVENT_TYPE", "SOURCE", "BEGIN_LAT", "BEGIN_LON", "END_LAT", "END_LON")
new_storm_1991 <- Storm_1991[limit_df]
head(new_storm_1991)

arrange(new_storm_1991, STATE)
state <- new_storm_1991

new_storm_1991$STATE = str_to_title(new_storm_1991$STATE)

filter(new_storm_1991, CZ_TYPE == 'C')
new_storm_1991 %>% select(-CZ_TYPE)

str_pad(new_storm_1991$STATE_FIPS, width = 3, side = "left", pad = "0")
str_pad(new_storm_1991$CZ_FIPS, width = 3, side = "left", pad = "0")
unite(new_storm_1991, "FIPS", c("STATE_FIPS", "CZ_FIPS"))

rename_all(new_storm_1991, tolower)

data("state")
us_state_info <- data.frame(state = state.name, region = state.region, area = state.area)

storm_1991_table <- data.frame(table(new_storm_1991$STATE))
head(storm_1991_table)

new_storm_1991_table <- (mutate_all(storm_1991_table,tolower))
merged <- merge(x = new_storm_1991_table, y = us_state_info, by.x = "state", by.y = "state")
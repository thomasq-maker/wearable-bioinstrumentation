# clear everything
rm(list = ls())
cat("\014")

# load packages
library(tidyverse)

# load data
data <- read_csv("C:/Users/tmqui/Downloads/Self_Tracking_Data.csv")

# clean column names
names(data) <- c("timestamp", "sleep_quality", "steps")

# convert timestamp to datetime
data <- data %>%
  mutate(timestamp = as.POSIXct(as.character(timestamp), format = "%m/%d/%Y"))

# remove empty rows
data <- data %>%
  filter(!(is.na(sleep_quality) & is.na(steps)))

# create tibble
data_tidy <- data %>%
  mutate(id = row_number()) %>%
  pivot_longer(
    cols = c(sleep_quality, steps),
    names_to = "feature",
    values_to = "value"
  ) %>%
  rename(time = timestamp) %>%
  select(id, time, feature, value)

# create summary statistics table
summary_table <- data_tidy %>%
  group_by(feature) %>%
  summarise(
    Units = case_when(
      feature == "sleep_quality" ~ "score",
      feature == "steps" ~ "count",
      TRUE ~ "-"
    ),
    Mean = mean(value, na.rm = TRUE),
    `Standard Deviation` = sd(value, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  rename(Feature = feature) %>%
  select(Feature, Units, Mean, `Standard Deviation`)

# view stats and data
print(data_tidy, n = Inf)
view(summary_table)

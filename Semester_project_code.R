# clear workspace
rm(list = ls())
cat("\014")
graphics.off()

# load packages
library(tidyverse)
library(ggnewscale)
library(scales)

# load data
data_raw <- read_csv("C:/Users/tmqui/Downloads/Self_Tracking_Data.csv")

#clean data
data <- data_raw %>%
  dplyr::select(where(~ !any(is.na(.))))

# rename columns if needed
names(data) <- c("date", "sleep_quality", "steps")

# convert date
data$date <- as.Date(data$date, format = "%m/%d/%Y")

# remove missing rows just in case
data <- data %>%
  filter(!is.na(date), !is.na(sleep_quality), !is.na(steps))

# -----------------------------
# PLOT 1: Daily step count bar plot
# -----------------------------
plot1 <- ggplot(data, aes(x = date, y = steps)) +
  geom_col(width = 0.8, fill = "steelblue") +
  scale_y_continuous(labels = comma) +
  scale_x_date(date_breaks = "1 day", date_labels = "%b %d") +
  labs(
    title = "Daily Step Count",
    subtitle = "Objective step count recorded each day",
    x = "Date",
    y = "Steps per Day",
    caption = "Figure 1. Bar chart of daily step count."
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    plot.caption = element_text(hjust = 0, face = "italic")
  ) +
  expand_limits(y = max(data$steps) * 1.12)

plot1

# -----------------------------
# PLOT 2: Sleep quality vs daily steps
# -----------------------------
plot2 <- ggplot(data, aes(x = sleep_quality, y = steps)) +
  geom_jitter(width = 0.12, height = 0, size = 3, alpha = 0.75, color = "darkorange") +
  geom_smooth(method = "lm", se = TRUE, linewidth = 1, color = "black") +
  scale_y_continuous(labels = comma) +
  scale_x_continuous(breaks = sort(unique(data$sleep_quality))) +
  labs(
    title = "Relationship Between Sleep Quality and Daily Steps",
    subtitle = "Higher sleep quality may be associated with changes in next-day activity",
    x = "Perceived Sleep Quality",
    y = "Total Daily Steps",
    caption = "Figure 2. Scatter plot withregression line showing the relationship between sleep quality and  daily step count."
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    plot.caption = element_text(hjust = 0, face = "italic")
  )

plot2

# -----------------------------
# PLOT 3: Heat map with different color scales
# -----------------------------
data_long <- data %>%
  pivot_longer(
    cols = c(sleep_quality, steps),
    names_to = "variable",
    values_to = "value"
  )

sleep_data <- data_long %>%
  filter(variable == "sleep_quality")

steps_data <- data_long %>%
  filter(variable == "steps")

plot3 <- ggplot() +
  geom_tile(
    data = sleep_data,
    aes(x = date, y = variable, fill = value),
    color = "white",
    linewidth = 0.8
  ) +
  scale_fill_gradient(
    low = "mistyrose",
    high = "firebrick",
    name = "Sleep Quality"
  ) +
  new_scale_fill() +
  geom_tile(
    data = steps_data,
    aes(x = date, y = variable, fill = value),
    color = "white",
    linewidth = 0.8
  ) +
  scale_fill_gradient(
    low = "lightblue",
    high = "navy",
    name = "Steps"
  ) +
  scale_x_date(date_breaks = "1 day", date_labels = "%b %d") +
  labs(
    title = "Heat Map of Sleep Quality and Daily Steps",
    subtitle = "Color intensity shows how each variable changes across time",
    x = "Date",
    y = "",
    caption = "Figure 3. Heat map of sleep quality and  daily step count across the study period."
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank(),
    plot.caption = element_text(hjust = 0, face = "italic"),
    legend.position = "right"
  )

plot3

cor.test(data$sleep_quality, data$steps, method = "spearman", exact = FALSE)


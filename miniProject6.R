# Mini-Project 6 Validation

# clear workspace
rm(list = ls())

# load packages
library(tidyverse)
library(magrittr)

# load data
data <- read.csv("C:/Users/tmqui/Downloads/rrData.csv") # adjust path to where your .csv file is, data should be 250 obs. x 4 variables
data$participant <- factor(data$participant) # make participant variable a factor
table(data$participant) # should be 10 repeats per participant


# LINE PLOT ----
# reshape the data into long format so that there are 4 columns: participant, time, feature (rr or rr_fft), and value
data_long <- data %>% 
  gather(Property, Value, rr:rr_fft) # fill gather() to create data_long which should be 500 obs. x 4 variables

# line plot
ggplot(data_long, aes(x = time, y = Value, color = Property)) +
  geom_line() +
  facet_wrap(~ participant) +
  labs(x = "Time (s)", y = "RR (brpm)", title ="Figure 1: Line Plot", color = "Feature") 

  
# BAR PLOT ----
# find the mean and standard deviation within each participant-feature
summary_data <- data_long %>% 
    group_by(participant, Property) %>% 
    summarize("Average" = mean(Value),"SD" = sd(Value)) # fill in group_by() and summarize() functions, should be 50 obs. x 4 variables

# bar plot
ggplot(summary_data, aes(x = participant, y = Average, fill = Property)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(x = "Participant", y = "RR (brpm)", title = "Figure 2: Bar Plot") 
  

# SCATTER PLOT ----
# fit linear model to data, y = rr_fft, x = rr)
fit <- lm(data$rr_fft ~ data$rr)

# combine text for equation
eq <- substitute(italic(y) == a + b %.% italic(x)*", "~~italic(r)^2~"="~r2, 
                 list(a = format(unname(coef(fit)[1]), digits = 2),
                      b = format(unname(coef(fit)[2]), digits = 2),
                      r2 = format(summary(fit)$r.squared, digits = 2)))
text <- as.character(as.expression(eq));

# scatter plot
ggplot(data, aes(x = rr, y = rr_fft)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  labs(x = "RR (brpm)", y = "RR FFT (brpm)", title = "Figure 3: Scatter Plot") 


# BLAND-ALTMAN PLOT ----
# calculate and save the differences between the two measures and the averages of the two measures
data %<>% 
  mutate(Difference = rr - rr_fft, Average = (rr + rr_fft)/2)

#compute the mean and limits of agreement (LoA)
Mean <- mean(data$Difference)
SD <- sd(data$Difference)

LoA_upper <- Mean + 1.96*SD
LoA_lower <- Mean - 1.96*SD

# Bland-Altman plot
ggplot(data, aes(x = Average, y = Difference)) +
  geom_point()+
  geom_hline(yintercept = Mean, color = "green", linetype = "solid")+
  geom_hline(yintercept = LoA_upper, color = "orange", linetype = "dashed")+
  geom_hline(yintercept = LoA_lower, color = "orange", linetype = "dashed")+
  labs(x = "Average of Measures (brpm)", y = "Differene of Measures (rr - rrfft) (brpm)", title = "Figure 4: Bland-Altman Plot") 


# BOX PLOT ----
# box plot
ggplot(data, aes(x = participant, y = Difference, fill = participant)) +
  geom_boxplot()
  labs(x = "Particpant", y = "Differene of Measures (rr - rrfft) (brpm)", title = "Figure 5: Box Plot") 
  
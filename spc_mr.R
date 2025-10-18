# %%
#' @name Create moving range SPC chart for a variable of interest
#' 
#' @description
#' This function calculates the moving range (absolute difference between consecutive daily
#'  peak values) for a variable of interest and produces a moving range chart using ggplot2.
#'  It also prints a tibble that assesses whether the data passes the eight SPC checks. 
#' 
#' @param date Date or POSIXct vector. Date corresponding to each measurement.
#' @param variable Numeric vector. Vector containing the variable of interest to analyze.
#' 
#' @return A ggplot2 object of the moving range chart.
#' 
#' @details
#' - The moving range is computed as the absolute difference between consecutive daily peaks.
#' - The upper control limit is calculated as the mean moving range plus 3 standard errors.
#' - The lower control limit is always set to 0 for moving range charts.
#' - Labels indicate the mean, upper control limit, and lower limit.
#' 
#' @import ggplot2
#' @import dplyr
#' @importFrom lubridate as_date
#' @export
#' 
#' @examples
#' \dontrun{
#' g_mr <- spc_moving_range(date, variable)
#' print(g_mr)
#' }

spc_moving_range = function(date, variable){

  library(ggplot2)
  library(dplyr)
  library (lubridate)

  # format data into a tibble
  data = tibble(
    date = date,
    variable = variable,
  )

  # calculate daily peak for the variable of interest
  daily_peaks <- data %>%
    mutate(date = as_date(date)) %>%
    group_by(date) %>% 
    reframe(
      peak_value = max(variable, na.rm = TRUE)
    )
    
  # calculate moving range statistics
  istat_s = daily_peaks %>%
    reframe(
      time = date[-1],
      # get moving range
      mr = peak_value %>% diff() %>% abs(),
      # Get average moving range
      mrbar = mean(mr, na.rm = TRUE),
      # Get total sample size!
      d2 = rnorm(n = 10000, mean = 0, sd = 1) %>% diff() %>% abs() %>% mean(),
      # If we approximate sigma_s....
      # pretty good!
      sigma_s = mrbar / d2,
      # Our subgroup size was 1, right?
      n = 1,
      # so this means sigma_s just equals the standard error here
      se = sigma_s / sqrt(n),
      # compute upper 3-se bound
      upper = mrbar + 3 * se,
      # and lower ALWAYS equals 0 for moving range
      lower = 0)


  # Let's get our labels!
  labels = istat_s %>%
    reframe(
      time = max(time), 
      type = c("mean", "+3 s", "lower"),
      value = c(mrbar[1],  upper[1], lower[1]) %>% round(2),
      name = paste(type, value, sep = " = "))

  # Now make the plot!
  g1 = istat_s %>%
    ggplot(mapping = aes(x = time, y = mr)) +
    # Plot the confidence intervals
    geom_ribbon(mapping = aes(x = time, ymin = lower, ymax = upper), 
                fill = "steelblue", alpha = 0.25) +
    # Plot mrbar
    geom_hline(mapping = aes(yintercept = mean(mr)), linewidth = 3, color = "darkgrey") +
    # Plot moving range
    geom_line(linewidth = 1) +
    geom_point(size = 5) +
    geom_label(data = labels, mapping = aes(x = time, y = value, label = name), hjust = 1) +  
    labs(x = "Date", y = "Moving Range",
        subtitle = "Moving Range Chart")+
    theme_classic()
    
    g1
  
  spc_test_results = spcTest(istat_s$mr, istat_s$se[1])
  print(spc_test_results)

  return(g1)


}


# %%
# %%
library(readr)
library(tidyverse)
library(lubridate)

panel_data = read_csv("louise.csv")

# for testing purposes, look at the first solar panel
date = panel_data$DateTime[1:(30*24)]
# eff = panel_data$eff[1:(30*24)]
variable = panel_data$power_output[1:(30*24)]
# irr = panel_data$irradiance[1:(30*24)]
g_mr = spc_moving_range(date, variable)

g_mr

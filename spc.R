
# %%

#' Create an average SPC chart for the max power output for each day

#' @import ggplot2
#' @import dplyr

# function w

spc_all = function(panel_id, variable, date){

  library(ggplot2)
  library(dplyr)

  # format data into a tibble
  data = tibble(
    date = date,
    variable = variable,
    panel_id = panel_id
  )

  # calculate daily peak for the variable of interest
  daily_peaks <- data %>%
    mutate(date = as_date(date)) %>%
    group_by(panel_id, date) %>% 
    reframe(
      peak_value = max(variable, na.rm = TRUE)
    ) %>% ungroup() %>% group_by(date)

  # need to calculate within-group statistics for average chart
  stat_s = daily_peaks %>% 
    # calculate statistics per subgroup
    summarize(
      sd = sd(variable, na.rm = TRUE),
      xbar = mean(variable, na.rm = TRUE),
      nw = n()
    )

  # calculate sigma short and se for average chart
  sigma_s = sqrt(mean((stat_s$sd)^2))
  se = sigma_s/sqrt(stat_s$nw %>% unique())

  # calculate lines for the average chart
  avg_lines = stat_s %>% reframe(
    xmin = min(date),
    xmax = max(date),
    xbbar = mean(xbar), # calculate grand mean
    ucl = xbbar + 3*se, # calculate upper limit
    lcl = xbbar - 3*se # calculate lower limit
  )

  # create text for labels for average chart
  labels = avg_lines %>% reframe(
    xpos = xmax,
    name = c("mean", "+3s", "-3s"),
    value = c(xbbar, ucl, lcl) %>% round(2),
    text = paste(name, value, sep = " = ")
  )

  # plot average chart
  g1 = ggplot() +
    # plot centerline
    geom_hline(data = avg_lines, mapping = aes(yintercept = xbbar), 
      color = "lightgrey", linewidth = 3) +
    # plot ucl
    geom_hline(data = avg_lines, mapping = aes(yintercept = ucl), 
      color = "lightgrey", linewidth = 1) +
    # plot lcl
    geom_hline(data = avg_lines, mapping = aes(yintercept = lcl), 
      color = "lightgrey", linewidth = 1) +
    # add ribbon between ucl and lcl
    geom_ribbon(mapping = aes(x = c(avg_lines$xmin, avg_lines$xmax), 
      ymin = c(1,1) * avg_lines$lcl, ymax = c(1,1) * avg_lines$ucl),
      fill = "mediumseagreen", alpha = 0.25) +
    # plot averages
    geom_point(data = stat_s, mapping = aes(x = date, y = xbar)) +
    geom_line(data = stat_s, mapping = aes(x = date, y = xbar)) +
    # add labels
    geom_label(data = labels, mapping = aes(x = xpos, y = value, label = text), 
      hjust = -.25) +
    theme_classic() +
    # add titles
    labs(
      subtitle = "Average Chart",
      y = "Max Power Output",
      x = "Time"
    ) +
    theme(plot.margin = unit(c(0.25,3,0.25,0.25), "cm")) + # adjust margins
    coord_cartesian(clip = "off") # turn off clipping

g1


}


# %%
library(readr)
library(tidyverse)
panel_data = read_csv("louise.csv")


sites = panel_data$site_id %>% unique()
indices = sites %>% match(panel_data$site_id)

# for testing purposes, look at the first site
date = panel_data$DateTime[1:(indices[2]-1)]
variable = panel_data$power_output[1:(indices[2]-1)]
site_id = panel_data$site_id[1:(indices[2]-1)]
panel_id = panel_data$panel_id[1:(indices[2]-1)]


g1 = spc_all(panel_id, variable, date)

g1


# %%
ggplot() + 
  geom_line(data = panel_data, mapping=aes(x = DateTime, y = eff))+
  geom_line(data = panel_data, mapping=aes(x = DateTime, y = power_output), color = "red")+
  geom_line(data = panel_data, mapping=aes(x = DateTime, y = irradiance/1000), color = "blue")


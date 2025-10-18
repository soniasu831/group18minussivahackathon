
# %%

#' @name spc_all
#' @title Create an average SPC chart for the max power output for each day
#' 
#' @description
#' This function calculates daily peak values for a specified variable (e.g. power output)
#'  across one or more panels, computes the daily mean, and control limits, 
#'  and produces an averages chart using ggplot2. It also prints a tibble that assesses 
#'  whether the data passes the eight SPC checks. 
#' 
#' @param panel_data a tibble, as outputted from add_efficiency()
#' @param site_id character, the unique ID of the solar panel farm of interest
#' @param var character, variable of interest - "e" for efficiency, "p" for power output
#' 
#' @return A ggplot2 of the average SPC chart.
#' 
#' @details
#' - Daily peaks are calculated for each panel, then averaged across panels.
#' - Control limits are calculated as the grand mean ± 3 standard erros.
#' - Ribbon highlights the control limits, and daily means are shown as points and lines.
#' 
#' @import ggplot2
#' @import dplyr
#' @importFrom lubridate as_date
#' @export
#' 
#' @examples
#' \dontrun{
#' g1 <- spc_all(panel_data, site_id, var)
#' print(g1)
#' }

spc_all = function(panel_data, site_id, var){

  library(ggplot2)
  library(dplyr)

  indices = which(panel_data$site_id == site_id)

  date = panel_data$DateTime[indices]
  panel_id = panel_data$panel_id[indices]
  power = panel_data$power_output[indices]
  eff = panel_data$eff[indices]

  if (var == "p"){
    # format data into a tibble
    data = tibble(
      date = date,
      variable = power,
      panel_id = panel_id
      )
  } else(
    # format data into a tibble
    data = tibble(
      date = date,
      variable = eff,
      panel_id = panel_id
    )
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
      sd = sd(peak_value, na.rm = TRUE),
      xbar = mean(peak_value, na.rm = TRUE),
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
      y = ifelse(var == "p","Average Daily Max Power Output (kW)",ifelse(var == "e", "Average Daily Max Efficiency", "Average")),
      x = "Date"
    ) +
    theme(plot.margin = unit(c(0.25,3,0.25,0.25), "cm")) + # adjust margins
    coord_cartesian(clip = "off") # turn off clipping

g1

spc_test_results = spcTest(stat_s$xbar, se)
print(spc_test_results)

return(g1)
  
}

# %%
# library(readr)
# panel_data = read_csv("louise.csv")

# site_id = panel_data$site_id[1]
# var = "e"

# g1 = spc_all(panel_data, site_id, var)

# g1

  

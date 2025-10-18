# this is an example of how you would use the provided packages 
# to perform an analysis on solar panel lifespan.

## LOAD IN LIBRARIES
# load in required libraries
library(dplyr)
library(httr)
library(dplyr)
library(ggplot2)
library(readr)

# load in our package
install.packages("monitorsolarpanels_1.0.tar.gz", type = "source")
library(monitorsolarpanels)

## ESTIMATE SOLAR PANEL EFFICIENCY
# start by querying the NASA Power API to estimate solar panel efficiency
your_data = "louise_raw.csv"
panel_data = panel_data = add_efficiency(your_data)


## REVIEW PROCESS INDICES
# a ppk index of above one indicates that the process is capable
# a ppk index of less than one indicates that the process is incapable

# review process indices for a given solar farm regarding power output per panel
output_specification = 0.4 # lower performance index for power output per solar panel
indices_farm = getPpks_farm(panel_data, output_specification)

# can also review process indices per solar panel assessing solar panel efficiency
indices_panel = getPpks_panel(panel_data) 

## EVALUATE PROCESS CONTROL CHARTS
# process control charts are helpful tools that reveal common
# cause and special cause variation


# for testing purposes, look at the first solar panel

# pull date data from panel_data tibble
date = panel_data$DateTime[1:(30*24)]
# pull power output data
power = panel_data$power_output[1:(30*24)]
mr_power = spc_moving_range(date, power)
mr_power

# we can also look at efficiency
eff = panel_data$eff[1:(30*24)]
mr_eff = spc_moving_range(date, eff)
mr_eff
# SPC test 4 fails, which indicates there may be a sustained shift

# we can also look at average spc charts for the whole farm

# for testing purposes, look at the first site
sites = panel_data$site_id %>% unique()
indices = sites %>% match(panel_data$site_id)

date = panel_data$DateTime[1:(indices[2]-1)]
variable = panel_data$power_output[1:(indices[2]-1)]
panel_id = panel_data$panel_id[1:(indices[2]-1)]

spc_avg = spc_all(panel_id, variable, date)
spc_avg
# here, test 6 fails, which indicates there may be special cause due
# to a faulty gauge 


## CALCULATE RELIABILITY

# Convert instalation dates from Excel serial dates
panel_data <- panel_data %>%
  mutate(
    Date = convert_excel_date(date),
    installation_date = convert_excel_date(installation_date)
  )

# Flag failures and calculate lambda per site
result <- flag_failures_lambda(
  panel_data,
  threshold = 0.75,
  date_col = "Date",
  eff_col = "eff",
  install_col = "installation_date",
  site_col = "site_id"
)

# Inspect results
print(result$panel_lifespans, n = Inf) # panel-level summary with site-level lambda
result$site_lambda                      # fleet lambda per site

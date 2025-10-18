# this is an example of how you would use the provided packages 
# to perform an analysis on solar panel lifespan.

# load in required libraries
library(tidyverse)
library(dplyr)
library(httr)
library(dplyr)
library(ggplot2)
library(readr)

# UPDATE THIS TO INCLUDE US LOADING IN OUR PACKAGE

## ESTIMATE SOLAR PANEL EFFICIENCY
# start by querying the NASA Power API to estimate solar panel efficiency
your_data = "louise.csv"
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

# %%
#' @name Pull NASA POWER Hourly Irradiance for One Location
#'
#' @description
#' This function queries the NASA POWER API to retrieve hourly solar irradiance,
#'  temperature, and clearness index for a given latitude, longitude, and date range.
#'
#' @param lat Numeric. Latitude of the site.
#' @param lon Numeric. Longitude of the site.
#' @param start_date Character. Start date in "YYYYMMDD" format.
#' @param end_date Character. End date in "YYYYMMDD" format.
#'
#' @return A data frame with DateTime (UTC), Irradiance (W/m²), Temperature (°C), and Clearness Index.
#' 
#' @details
#' - This function uses the NASA POWER API's "temporal/hourly/point" endpoint.
#' - The API returns hourly data in UTC. If the API request fails the function stops and prints HTTP code.
#' 
#' @import httr
#' @import dplyr
#' @export
#'
#' @examples
#' \dontrun{
#' df <- pull_nasa_power_point(42.44, -76.50, "20230101", "20230102")
#' head(df)
#' }

pull_nasa_power_point <- function(lat, lon, start_date, end_date) {
  library(httr)
  library(dplyr)
  
  base_url <- "https://power.larc.nasa.gov/api/temporal/hourly/point"
  
  # Build query
  response <- GET(
    url = base_url,
    query = list(
      parameters = "ALLSKY_SFC_SW_DWN,ALLSKY_KT,T2M",
      community = "RE",
      longitude = lon,
      latitude = lat,
      start = start_date,
      end = end_date,
      format = "JSON"
    )
  )
  
  # Check response
  if (status_code(response) != 200) {
    stop("NASA POWER API request failed! HTTP code: ", status_code(response))
  }
  
  # Parse JSON
  data <- content(response, "parsed", simplifyVector = TRUE)
  
  # Extract parameters
  params <- data$properties$parameter
  timestamps <- names(params$ALLSKY_SFC_SW_DWN)
  
  df <- data.frame(
    DateTime = as.POSIXct(strptime(timestamps, "%Y%m%d%H", tz = "UTC")),
    Irradiance_Wm2 = as.numeric(params$ALLSKY_SFC_SW_DWN),
    Clearness_Index = as.numeric(params$ALLSKY_KT),
    Temperature_C = as.numeric(params$T2M),
    lat = lat,
    lon = lon
  )
  
  message("Retrieved ", nrow(df), " hourly records for ", lat, ",", lon)
  return(df)
}



# %%

#' Calculate efficiency based on solar irradience from NASA POWER API
#'
#' @param panel_csv solar panel data as a .csv 
#'
#' @import readr
#' @import dplyr
#' @export
#'
#' @examples
#' panel_data = add_efficiency("adjusted_dates.csv")

add_efficiency <- function(panel_csv) {

  library(readr)
  library(dplyr)

  panel_data <- read_csv(panel_csv, col_types = cols(
    panel_id = col_character(),
    power_output = col_double(),
    date = col_double(),
    time = col_character(),
    lat = col_double(),
    lon = col_double(),
    panel_area = col_double()
  ))
  
  panel_data <- panel_data %>%
    mutate(
      time = trimws(time),                              # clean whitespace
      Date = as.Date(date, origin = "1899-12-30"),      # Excel serial -> Date
    )

  start_date <- min(panel_data$Date) %>% format("%Y%m%d")  # YYYYMMDD
  end_date   <- max(panel_data$Date) %>% format("%Y%m%d")  # YYYYMMDD

  indices = match(unique(panel_data$site_id), panel_data$site_id)
  indices = indices %>% append(length(panel_data$site_id))

  irr_time = c()
  irr = c()
  irr_lat = c()
  irr_lon = c()
  # efficiency = power / (irradience * A)
  for (i in 1:(length(indices)-1)){
    min_index = indices[i]
    max_index = indices[i+1]-1
    nasa_data = pull_nasa_power_point(panel_data$lat[min_index], panel_data$lon[min_index], start_date, end_date)
    irr_time = irr_time %>% append(nasa_data$DateTime)
    irr = irr %>% append(nasa_data$Irradiance_Wm2)
    irr_lat = irr_lat %>% append(nasa_data$lat)
    irr_lon = irr_lon %>% append(nasa_data$lon)
  }

  irr_data = tibble(
    DateTime = irr_time,
    irradiance = irr,
    lat = irr_lat,
    lon = irr_lon
  )

  panel_data = panel_data %>% mutate(
    DateTime = as.POSIXct(Date + lubridate::hms(time)),
  ) %>% left_join(irr_data, by = c("lat", "lon", "DateTime"))


  # kW * 1000 / (Wm^2 * cm^2 * 0.0001)
  panel_data = panel_data %>% mutate(
    eff = (power_output * 1000) / (irr * panel_area * 0.0001)
  )

  # set minimum irradiance for calculating efficiency
  panel_data$eff = ifelse(panel_data$irradiance > 150, panel_data$eff, 0)

  # cap efficiency at 1
  panel_data$eff = ifelse(panel_data$eff > 1, 1, panel_data$eff)

  panel_data = panel_data %>% 
  select(-Date)


  return(panel_data)
}


# %%
panel_data = add_efficiency("test_again_with_jitter.csv")

write.csv(panel_data,"louise.csv", row.names = FALSE)




# =========================================
#' @name convert_excel_date
#' @title Excel date conversion helper
#' @description Convert Excel serial dates to R Date format
#' @param date Numeric. Date in Excel serial format.
#' @return A date object in YYYY-MM-DD format

convert_excel_date <- function(excel_date){
  as.Date(excel_date, origin = "1899-12-30")
}


#' @name solar_df
#' @title Solar panel failures and site Lambda
#' 
#' @description
#' This function flags solar panel efficiency failures based on a threshold of 
#'  the panel's maximum efficiency, calculates time to failure per panel, and 
#'  computes the failure rate per site.
#' 
#' @param df Data frame. Must include columns for efficiency, site ID, installation date, and measurement date.
#' @param threshold Numeric. Fraction of maximum efficiency below which a panel is considered to have 
#'  failed (default = 0.7)
#' @param date_col Character. Measurement dates.
#' @param eff_col Numeric. Efficiency values.
#' @param install_col Date or POSIXct. Date of installation.
#' @param site_col Character. Site IDs.
#' 
#' @return a list containing
#' 
#' @import dplyr
#' @import readr
#' @import lubridate
#' @export
#' 
#' @examples
#' \dontrun{
#' solar_df <- read_csv("louise.csv") %>%
#'   mutate(
#'     Date = as.Date(date, origin = "1899-12-30"),
#'     installation_date = as.Date(installation_date, origin = "1899-12-30")
#'   )
#' 
#' # Run failure flagging and lambda calculation
#' result <- flag_failures_lambda(solar_df, threshold = 0.75)
#' result$panel_lifespans
#' result$site_lambda
#' }

# =========================================
# Load required packages
# library(dplyr)
# library(lubridate)
# library(readr)

# =========================================
# Flag failures and calculate lambda per site
flag_failures_lambda <- function(df, threshold = 0.7, date_col = "Date", eff_col = "eff", install_col = "installation_date", site_col = "site_id") {
  
  # Flag failures per panel
  df_flagged <- df %>%
    group_by(panel_id) %>%
    mutate(
      max_eff = max(.data[[eff_col]], na.rm = TRUE),
      max_eff = ifelse(is.infinite(max_eff), NA, max_eff),
      failure_flag = ifelse(
        is.na(max_eff), 
        NA, 
        if_else(.data[[eff_col]] < threshold * max_eff, 1, 0)
      )
    ) %>%
    ungroup()
  
  # Calculate time to failure per panel directly
  panel_lifespans <- df_flagged %>%
    group_by(panel_id, .data[[site_col]]) %>%
    summarize(
      start_date = min(.data[[install_col]], na.rm = TRUE),
      t_fail = {
        fail_dates <- .data[[date_col]][failure_flag == 1]
        if(length(fail_dates) > 0) {
          as.numeric(min(fail_dates, na.rm = TRUE) - start_date)
        } else {
          NA_real_
        }
      },
      ever_failed = any(failure_flag == 1, na.rm = TRUE),
      .groups = "drop"
    )
  
  # Calculate lambda per site
  site_lambda <- panel_lifespans %>%
    group_by(.data[[site_col]]) %>%
    summarize(
      site_lambda = 1 / mean(t_fail, na.rm = TRUE),
      .groups = "drop"
    )
  
  # Merge site lambda back into panel summary
  panel_lifespans <- panel_lifespans %>%
    left_join(site_lambda, by = site_col)
  
  # Return results
  return(list(
    flagged_data = df_flagged,
    panel_lifespans = panel_lifespans,
    site_lambda = site_lambda
  ))
}

# # =========================================
# # Read dataset
# solar_df <- read_csv("louise.csv")

# # Convert Excel serial dates
# solar_df <- solar_df %>%
#   mutate(
#     Date = convert_excel_date(date),
#     installation_date = convert_excel_date(installation_date)
#     # Optional: create POSIX datetime if you have a time column
#     # DateTime = as.POSIXct(paste(Date, time), format = "%Y-%m-%d %H:%M:%S")
#   )

# # =========================================
# # Flag failures and calculate lambda per site
# result <- flag_failures_lambda(
#   solar_df,
#   threshold = 0.75,
#   date_col = "Date",
#   eff_col = "eff",
#   install_col = "installation_date",
#   site_col = "site_id"
# )

# # =========================================
# # Inspect results
# print(result$panel_lifespans, n = Inf) # panel-level summary with site-level lambda
# result$site_lambda                      # fleet lambda per site

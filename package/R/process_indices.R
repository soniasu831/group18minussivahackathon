# %%

#' @name ppk
#' @title Process Performance Index (for skewed, uncentered data)
#' 
#' @description
#' Calculates the process performance index given a process mean, standard deviation, 
#'  and specification limits.
#' 
#' @param mu Numeric. Process mean.
#' @param sigma_t Numeric. Process standard deviation.
#' @param lower Numeric of NULL. Lower specification limit.
#' @param upper Numeric or NULL. Upper specification limit.
#' 
#' @return Numeric. The calculated Ppk value.
#' 
#' @details
#' - Ppk is used to evaluate process performance relative to specification limits
#' 
#' @export
#' 
#' @examples
#' ppk(0.18, 0.02, lower = 0.17, upper = 0.20)
#' ppk(0.18, 0.02, upper = 0.20)
#' ppk(0.18, 0.02, lower = 0.17)

ppk = function(mu, sigma_t, lower = NULL, upper = NULL){
  if(!is.null(lower)){
    a = abs(mu - lower) / (3 * sigma_t)
  }
  if(!is.null(upper)){
    b = abs(upper - mu) /  (3 * sigma_t)
  }
  # We can also write if else statements like this
  # If we got both stats, return the min!
  if(!is.null(lower) & !is.null(upper)){
    min(a,b) %>% return()
    
    # If we got just the upper stat, return b (for upper)
  }else if(is.null(lower)){ return(b) 
    
    # If we got just the lower stat, return a (for lower)
  }else if(is.null(upper)){ return(a) }
}




# %%
#' @name getPpks_panel
#' @title Get Process Performance Index for each Solar Panel
#' 
#' @description
#' Calculates the process performance index for each solar panel based on the 
#' nominal efficiency for each solar panel type (M, P, or T)
#' 
#' @param panel_data a tibble, as outputted from add_efficiency()
#' 
#' @return a tibble containing the calculated Ppk value for each solar panel
#' 
#' @details
#' - Ppk is used to evaluate process performance relative to specification limits. 
#' Here, the specification limit used is the nominal efficiency for each solar panel time
#' 
#' @import dplyr
#' @export
#' 
#' @examples
#' indices_p = getPpks_panel(panel_data)
#' 
getPpks_panel = function(panel_data){

  # nominal efficiency based on solar panel type
  nominal_eff = tibble(
      m = 0.20,
      p = 0.17,
      t = 0.12
  )

  indices = panel_data %>% group_by(panel_id, panel_type) %>% reframe(
      mu = mean(eff),
      sigma_t = sd(eff),
  ) %>% reframe(
      panel_id = panel_id,
      ppk = case_when(
          panel_type == "M" ~ ppk(mu, sigma_t, nominal_eff$m),
          panel_type == "P" ~ ppk(mu, sigma_t, nominal_eff$p),
          panel_type == "T" ~ ppk(mu, sigma_t, nominal_eff$t)
      )
  )

  return(indices)

}


# %%

# %%
#' @name getPpks_farm
#' @title Get Process Performance Index for Solar Farm
#' 
#' @description
#' Calculates the process performance index for each solar farm based on a
#' specified power output specification
#' 
#' @param panel_data a tibble, as outputted from add_efficiency()
#' @param power_spec numeric, the per solar panel power output specification 
#' for the solar farm
#' 
#' @return a tibble containing the calculated Ppk value for each solar far based on
#' a per solar panel power output specification
#' 
#' @details
#' - Ppk is used to evaluate process performance relative to specification limits. 
#' Here, the specification limit used is provided by the user as power_spec
#' 
#' @import dplyr
#' @export
#' 
#' @examples
#' indices_f = getPpks_farm(panel_data, 0.4)
#' 
getPpks_farm = function(panel_data, power_spec){

  indices = panel_data %>% group_by(site_id) %>% reframe(
      mu = mean(power_output),
      sigma_t = sd(power_output),
  ) %>% reframe(
      site_id = site_id,
      ppk = ppk(mu, sigma_t, power_spec)
      )

  return(indices)

}

# # %%

# library(readr)
# library(tidyverse)

# panel_data = read_csv("louise.csv")
# indices_p = getPpks_panel(panel_data)
# indices_f = getPpks_farm(panel_data, 0.4)

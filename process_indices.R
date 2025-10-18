# %%

#' Process Performance Index (for skewed, uncentered data)
#' @input mu, process mean
#' @input sigma_t, process standard deviation
#' @input lower, lower specification limit
#' @input upper, upper specification limit
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

#' Function to evaluate Ppks for solar panel efficiency on a per-solar panel level 
#' @import dplyr
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

# %%

library(readr)
library(tidyverse)

panel_data = read_csv("louise.csv")
indices_p = getPpks_panel(panel_data)
indices_f = getPpks_farm(panel_data, 0.4)
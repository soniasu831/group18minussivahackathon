# Six Sigma Hackathon: group18minussiva

### Problem Statement
Utility scale solar power plants are found all throughout New York state, due to significant promotion policies over the last decade. Utility scale solar can be made up of hundreds or even thousands of solar panels, each of which requires routine maintenance. Your team has been commissioned by the New York State Energy Research & Development Authority (NYSERDA), whose staff hope to better understand the lifespan remaining for existing utility-scale solar farms. Design a quality control system to track and mitigate solar panel failure.

## Solar Panel Data
Each row represents solar panel data collected from utility-scale solar farms. 

### Column Descriptions

| Column | Description |
| -------- | -------- |
| `panel_id`  | Unique identifier for solar panel  |
| `power_output` | Solar panel power output (kW) |
| `date` | Date of measurement (Excel serial format) |
| `time` | Time of measurement (24 hour format) |
| `lat` | Lattitude of solar panel farm |
| `lon` | Longitude of solar panel farm |
| `site_id`  | Unique identifier for solar farm |
| `installation date` | Date that the solar panel was installed (Excel serial format) |
| `manufacturer` | Manufacturer of the solar panel |
| `batch model ` | Batch model for solar panel |
| `model` | Model number for solar panel |
| `panel_type` | Panel type: M (monocrystalline), P (polycrystalline), T (thin-film) |
| `panel_area` | Surface area of solar panel (cm^2) |

### Package Dependencies
Imports: 
  dplyr (>= 1.1.4),
  httr (>= 1.4.7),
  ggplot2 (>= 4.0.0),
  readr (>= 2.1.5),
  lubridate (>= 1.9.4)

### Tool Description 
This six sigma hackathon project tool was built for the operations team at NYSERDA. This project integrates solar panel performance monitoring with advanced statistical process control(SPC) and failure analysis to optimize solar farm operations. The project begins by importing user provied solar panel data (panel_id,power_output,date,time,latitude, lonngitude, site_id, installation date, manufacturer,batch model, model, panel_type, panel_area) and illiciting environmental irradiance, temperature, and clearness index by querying the NASA POWER API. Utilizing this combined data, panel efficiency is calculated. The function to calculate efficiency calculates the panel's maximum efficiency, calculates time to failure per panel, and computes the failure rate per site reflecting the real-world operating conditions.
Process performance indices are computed at both the solar farm and individual panel levels to evaluate process stability and detect anomalies. The core function calculates the Process Performance Index (Ppk) using key statistical parameters: the process mean (mu), process standard deviation (sigma_t), and specification limits. This index assesses how well the process aligns with predefined acceptable limits, accounting for skewed or uncentered data distributions. Specifically, the project calculates the Ppk for each solar panel based on nominal efficiency thresholds unique to panel types (monocrystalline "M", polycrystalline "P", or thin-film "T"). At the solar farm level, Ppk is computed with respect to a user-defined power output specification to reflect site-wide performance stability. These indices utilize variables from the dataset such as panel efficiency (eff), power output (power_output), panel type (panel_type), and site identifier (site_id) to quantify how consistently panels and farms operate within anticipated performance limits, providing actionable insights for quality control and maintenance prioritization.
For process monitoring, SPC methods include creating average control charts of daily peak power outputs calculated from variables such as solar panel identifiers (panel_id), measurement dates (date or DateTime), and power output values (power_output). The process involves grouping data by panel and day to determine daily peak values, then computing daily means (xbar), pooled standard deviation (sigma_s), and control limits (upper and lower control limits) based on the grand mean (xbbar). This approach provides a clear visual representation of day-to-day performance variations across panels, enabling effective monitoring of process stability and early detection of anomalies.A moving range (MR) SPC chart reveals variability by evaluating absolute differences between consecutive daily peaks, calculated from variables such as measurement dates (date) and the variable of interest (e.g., power_output). The moving range is computed as the absolute difference between consecutive daily maxima, with control limits determined using the mean moving range plus three standard errors, and the lower control limit set to zero. This function evaluates whether a process is statistically in control by analyzing the specified averages against the process variability sigma. By detecting specific patterns such as runs below/above control limits, trends, or oscillations, it helps identify out-of-control conditions or shifts in the process.Each test targets specific behavior in the data that may indicate process shifts or irregularities. These SPC analyses start at the farm level and can be drilled down to individual solar panels, allowing targeted troubleshooting of anomalous sites. 
Overall, this comprehensive approach empowers data-driven decision-making to maintain optimal solar farm performance, improve reliability, and reduce failures through robust monitoring and statistical quality control.

# Import and Environmental Data Integration
## Variables:
1. panel_id
2. power_output
3. date
4. time
5. latitude
6. longitude
7. site_id
8. installation_date
9. manufacturer
10. batch_model
11. model
12. panel_type
13. panel_area
## Description:
This function imports user-provided solar panel data and enriches it by querying the NASA POWER API to obtain environmental variables such as irradiance, temperature, and clearness index. This combined dataset forms the basis for further performance and failure analyses under real-world conditions.

# Efficiency Calculation and Failure Function
## Variables:
1. Calculated panel efficiency (eff)
2. Panel maximum efficiency (derived)
## Description:
Calculates solar panel efficiency from the combined data, identifies when efficiency falls below a threshold related to each panel’s maximum efficiency, computes the time to failure for each panel, and calculates failure rates at each site. This function supports early detection of underperforming or failing panels for proactive maintenance.

# Process Performance Index Calculation
## Variables:
1. Process mean (mu)
2. Process standard deviation (sigma_t)
3. Specification limits (nominal efficiency thresholds per panel type and user-defined power specs per site)
4. Panel efficiency (eff)
5. Power output (power_output)
6. Panel type (panel_type)
7. Site identifier (site_id)
## Description:
Computes the Process Performance Index (Ppk) to evaluate process stability and alignment with specification limits. For individual panels, Ppk is calculated based on nominal efficiencies specific to the panel type (M, P, or T). For solar farms, Ppk uses a specified power output limit. This index quantifies how consistently both panels and farms operate within desired performance boundaries, offering actionable insights for quality control and maintenance prioritization.

# Average Control Chart Creation (SPC)
## Variables:
1. Solar panel identifiers (panel_id)
2. Measurement dates (date or DateTime)
3. Power output values (power_output)
4. Daily peak values
5. Daily means (xbar)
6. Pooled standard deviation (sigma_s)
7. Control limits (upper and lower, based on grand mean xbbar)
## Description:
Generates average control charts by calculating daily peak power outputs across panels, then computing daily means and control limits. This visualizes day-to-day performance variations, enabling effective process stability monitoring and early anomaly detection.

# Moving Range (MR) SPC Chart
## Variables:
1. Measurement dates (date)
2. Variable of interest (e.g., power_output)
3. Moving range (absolute difference between consecutive daily peaks)
4. Mean moving range (mrbar)
5. Control limits (mean moving range plus 3 standard errors; lower limit fixed at zero)
## Description:
Calculates the moving range of daily peak values to reveal variability in the process. The function produces moving range SPC charts with calculated upper control limits and assesses process control through standard SPC anomaly tests.

# SPC Tests on Subgroup
## Variables:
1. Subgroup averages (averages)
2. Standard deviation of subgroup averages (sigma)
3. Statistical control zones and rules (e.g., 1s, 2s, 3s zones)
## Description:
Evaluates whether a data vector passes eight standard SPC tests designed to detect patterns such as single points beyond control limits, runs of points beyond specific sigma zones, sustained trends, and oscillations. These tests identify potential process shifts or irregularities. The SPC analyses begin at the solar farm level and can be drilled down to individual solar panels, enabling targeted troubleshooting of anomalies.
Furthermore, standard SPC tests analyze these data to detect anomalies by checking for different types of patterns such as runs below or above control limits, trends, or oscillations. Each test targets specific behavior in the data that may indicate process shifts or irregularities. These SPC analyses start at the farm level and can be drilled down to individual solar panels, allowing targeted troubleshooting of anomalous sites.

This comprehensive approach empowers data-driven decision-making to maintain optimal solar farm performance, improve reliability, and reduce failures through robust monitoring and statistical quality control.

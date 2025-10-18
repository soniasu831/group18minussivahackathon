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


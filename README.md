# Six Sigma Hackathon: group18minussiva

## Problem Statement
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
| `installation_date` | Date that the solar panel was installed (Excel serial format) |
| `manufacturer` | Manufacturer of the solar panel |
| `batch model ` | Batch model for solar panel |
| `model` | Model number for solar panel |
| `panel_type` | Panel type: M (monocrystalline), P (polycrystalline), T (thin-film) |
| `panel_area` | Surface area of solar panel (cm^2) |

## Package Dependencies
Imports: 
  dplyr (>= 1.1.4),
  httr (>= 1.4.7),
  ggplot2 (>= 4.0.0),
  readr (>= 2.1.5),
  lubridate (>= 1.9.4)

## Tool Description 
This six sigma hackathon project tool was built for the operations team at NYSERDA. This project integrates solar panel performance monitoring with advanced statistical process control(SPC) and failure analysis to optimize solar farm operations.The users interact with the failure rates via the R package.

**What Users Get Back**

The users receive actionable outputs such as:
1. CSV files with detailed failure probabilities by panels or sites.
2. Data frames in analytical environments for further custom analysis.
3. Plots and visualizations showing failure trends, predicted risk levels, and thresholds, enabling quick interpretation of system health.

**Stakeholder-Oriented Documentation**

To communicate effectively with stakeholders (e.g., Operations managers):
1. Explain the purpose: The tool predicts panels that are likely to fail soon, providing estimates on how many need replacement to avoid downtime.
2. Highlight the key outputs: Clear CSV reports list panels flagged for replacement
3. Describe user interaction: Operations staff upload or connect data feeds, then receive intuitive tables, charts, and alerts.
4. Recommend actions: Do use the predictive outputs for proactive maintenance scheduling; do not rely solely on manual inspections post-failure.
5. Emphasize benefits: Reduced unplanned outages, optimized maintenance cost and resource allocation, and maximized solar energy production.

**Direct Recommendation**

Use the generated CSV and visualization reports for prioritizing replacement and act promptly on interventions once thresholds for failure risk are reached.


### Import and Environmental Data Integration
#### Variables:
1. Unique identifier for solar panel (panel_id)
2. Solar panel power output (power_output)
3. Date of measurement (date)
4. Measurement time (time)
5. Latitude of solar farm (latitude)
6. Longitude of solar farm (longitude)
7. Unique identifier for Site (site_id)
8. Date of installation (installation_date)
9. Manufacturer of solar panel (manufacturer)
10. Batch model for solar panel (batch_model)
11. Modal number for solar panel (model)
12. panel type (panel_type)
13. Surface area of solar panel (panel_area)
#### Description:
This function imports user-provided solar panel data and enriches it by querying the NASA POWER API to obtain environmental variables such as irradiance, temperature, and clearness index. This combined dataset forms the basis for further performance and failure analyses under real-world conditions.

### Efficiency Calculation and Failure Function
#### Variables:
1. Calculated panel efficiency (eff)
2. Panel maximum efficiency (derived)
#### Description:
Calculates solar panel efficiency from the combined data, identifies when efficiency falls below a threshold related to each panel’s maximum efficiency, computes the time to failure for each panel, and calculates failure rates at each site. This function supports early detection of underperforming or failing panels for proactive maintenance.

### Process Performance Index Calculation
#### Variables:
1. Process mean (mu)
2. Process standard deviation (sigma_t)
3. Specification limits (nominal efficiency thresholds per panel type and user-defined power specs per site)
4. Panel efficiency (eff)
5. Solar panel power output (power_output)
6. Panel type (panel_type)
7. Unique identifier for site (site_id)
#### Description:
Computes the Process Performance Index (Ppk) to evaluate process stability and alignment with specification limits. For individual panels, Ppk is calculated based on nominal efficiencies specific to the panel type (M, P, or T). For solar farms, Ppk uses a specified power output limit. This index quantifies how consistently both panels and farms operate within desired performance boundaries, offering actionable insights for quality control and maintenance prioritization.

### Average Control Chart Creation (SPC)
#### Variables:
1. Unique identifier for solar panel (panel_id)
2. combined date and time of measurement for NASA API (date or DateTime)
3. Solar panel ower output (power_output)
4. Daily peak values
5. Daily means (xbar)
6. Pooled standard deviation (sigma_s)
7. Control limits (upper and lower, based on grand mean xbbar)
#### Description:
Generates average control charts by calculating daily peak power outputs across panels, then computing daily means and control limits. This visualizes day-to-day performance variations, enabling effective process stability monitoring and early anomaly detection.

### Moving Range (MR) SPC Chart
#### Variables:
1. Measurement dates (date)
2. Variable of interest (e.g., power_output)
3. Moving range (absolute difference between consecutive daily peaks)
4. Mean moving range (mrbar)
5. Control limits (mean moving range plus 3 standard errors; lower limit fixed at zero)
#### Description:
Calculates the moving range of daily peak values to reveal variability in the process. The function produces moving range SPC charts with calculated upper control limits and assesses process control through standard SPC anomaly tests.

### SPC Tests on Subgroup
#### Variables:
1. Subgroup averages (averages)
2. Standard deviation of subgroup averages (sigma)
3. Statistical control zones and rules (e.g., 1s, 2s, 3s zones)
#### Description:
Evaluates whether a data vector passes eight standard SPC tests designed to detect patterns such as single points beyond control limits, runs of points beyond specific sigma zones, sustained trends, and oscillations. These tests identify potential process shifts or irregularities. The SPC analyses begin at the solar farm level and can be drilled down to individual solar panels, enabling targeted troubleshooting of anomalies.
Furthermore, standard SPC tests analyze these data to detect anomalies by checking for different types of patterns such as runs below or above control limits, trends, or oscillations. Each test targets specific behavior in the data that may indicate process shifts or irregularities. These SPC analyses start at the farm level and can be drilled down to individual solar panels, allowing targeted troubleshooting of anomalous sites.

This comprehensive approach empowers data-driven decision-making to maintain optimal solar farm performance, improve reliability, and reduce failures through robust monitoring and statistical quality control.

**Inputs and Parameters of the functions used**

### Solar panel failure 

Flag Failure (lambda) Function 

# Inputs: 
Date, threshold, efficiency, installation date, site id
# Parameters: 
Location (determined by site id), and the distribution

#### Description:

The function begins with loading and processing solar panel sensor data into a data frame and then computing efficiency as a new column, followed by grouping panel ID data and summarizing the maximum efficiency. We then finalize by calculating the mean efficiency and applying the failure model to predict failure predictability and output results as a plot.

### Time to failure per panel - Function 

# Inputs: 
panel id, site, start dates (describing when the panel started generating the energy), fail dates, 
# Parameters: 
Location (determined by site id), and the distribution

#### Description: 

The time to failure (TTF) per solar panel is calculated by subtracting the commissioning date (start date) from the failure occurrence time for each panel. This involves generating a new column representing TTF by computing the difference between failure timestamps and the start of operation. These TTF values are then used to fit reliability distributions that model the failure probability over time. This statistical modeling supports predicting when panels will fail, facilitating proactive maintenance and replacement scheduling based on calculated failure risks and characteristic life parameters. Outputs include data frames and summary reports to aid operational decision-making.

### Lambda per site - Function

# Inputs: 
Date, threshold, efficiency, installation date, site id
# Parameters: 
Mean, location (determined by site id), and the distribution

#### Description: 

Lambda (λ) per site represents the failure rate, indicating the frequency of solar panel failures over a specified time interval at that site. λ quantifies how often failures occur, assuming a constant failure rate, and feeds into reliability distributions.

### Process Indices – Performance Index Function

### 1. Ppk relative to specification limits - Function
Inputs: mu (mean (efficiency), sigma sd(efficiency), LCL, UCL

#### Description: 
Ppk (Process Performance Index) measures how well a process performs relative to its specification limits by considering both centering (mean) and overall variability (standard deviation) in real operation. The x ˉ is the sample mean, s is the sample standard deviation, and USL and LSL are upper and lower specification limits, respectively. It reflects the actual performance, including any shifts or drifts

### 2. PPK for each solar panel - Function
Inputs: panel data, power specs, mu (mean (efficiency), sigma sd(efficiency), LSL, USL
Parameters: USL, LSL, Mean & Sd

### SPC Function
Inputs: panel id, variable, date
Parameters: Daily peaks, sigma short, moving range statistics, lines for average chart

### ggplot function

Inputs: time, mr (peak value), mrbar, d2, sigma_s, standard error, upper and lower mrbar
Parameters: Daily peaks, sigma short, moving range statistics, lines for average chart

#### Description:

Statistical Process Control (SPC) in solar panel operations uses control charts and statistical methods to monitor and control manufacturing and operational processes, ensuring stable quality and identifying variations that may lead to failures. SPC involves collecting data on key process variables (e.g., efficiency, temperature), plotting control charts (package), and detecting signals outside control limits indicating process drift or anomalies. This real-time monitoring helps maintain defect-free panel production, optimize maintenance schedules, and improve overall system reliability. SPC outputs include visual control charts and summary statistics that guide operational adjustments to reduce variability and enhance panel performance.


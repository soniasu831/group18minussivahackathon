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
This six sigma hackathon project tool was built for the operations team at NYSERDA. This project integrates solar panel performance monitoring with advanced statistical process control(SPC) and failure analysis to optimize solar farm operations.The users interact with the failure rates via the R package. [Main.R](main.R) is an example of how this package can be used to analyze solar panel farms.

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

### Quick Links
- [Tests Guide](docs/TestGuide.md) for details on the tests this package can run, with additional information on the necessary variable inputs.
- [Functions Guide](docs/FunctionDescriptions.md) for details on the inputs and parameters of the functions used.
- [Test Data Set 1](louise_raw.csv)
- [Test Data Set 2](sonia3.csv)
- [Test Data Set 3](fixed_power.csv)


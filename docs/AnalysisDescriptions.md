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



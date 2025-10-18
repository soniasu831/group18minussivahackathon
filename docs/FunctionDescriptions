**Inputs and Parameters of the functions used**

### Solar panel failure 

Flag Failure (lambda) Function 

#### Inputs: 
Date, threshold, efficiency, installation date, site id
#### Parameters: 
Location (determined by site id), and the distribution

#### Description:

The function begins with loading and processing solar panel sensor data into a data frame and then computing efficiency as a new column, followed by grouping panel ID data and summarizing the maximum efficiency. We then finalize by calculating the mean efficiency and applying the failure model to predict failure predictability and output results as a plot.

### Time to failure per panel - Function 

#### Inputs: 
panel id, site, start dates (describing when the panel started generating the energy), fail dates, 
#### Parameters: 
Location (determined by site id), and the distribution

#### Description: 

The time to failure (TTF) per solar panel is calculated by subtracting the commissioning date (start date) from the failure occurrence time for each panel. This involves generating a new column representing TTF by computing the difference between failure timestamps and the start of operation. These TTF values are then used to fit reliability distributions that model the failure probability over time. This statistical modeling supports predicting when panels will fail, facilitating proactive maintenance and replacement scheduling based on calculated failure risks and characteristic life parameters. Outputs include data frames and summary reports to aid operational decision-making.

### Lambda per site - Function

#### Inputs: 
Date, threshold, efficiency, installation date, site id
#### Parameters: 
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

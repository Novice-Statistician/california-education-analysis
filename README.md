# Education Equity & District Performance Analysis

Author: Zachary Niccoli

Tools: Python (Pandas, NumPy, MatPlotLib, Seaborn, Statsmodels, Sqlalchemy), PostgreSQL, Tableau

Years Analyzed: 2021–2024

Data Source: California Department of Education (via ed-data.org)

## Project Overview

This project evaluates district level math achievement across California and examines whether districts perform above or below expectations given their socioeconomic conditions.

Using regression modeling, I estimate predicted math proficiency based on a constructed Socioeconomic Status (SES) Index and funding levels. I then calculate a performance gap to identify districts that outperform or underperform structural expectations.

The final output includes:

- A fully documented Python modeling workflow

- A normalized PostgreSQL schema (dimension + fact tables)

- Interactive Tableau dashboards for statewide and district-level exploration

This project demonstrates an end-to-end analytics pipeline from raw data to executive-ready reporting.

## Objectives

- Quantify the relationship between socioeconomic disadvantage and math achievement

- Evaluate whether funding offsets socioeconomic conditions

- Identify districts outperforming predicted achievement levels

- Build SQL-ready datasets for dashboard reporting

## Methodology
### Data Preparation

- Combined three years of district-level academic and financial data

- Cleaned suppressed and formatted numeric fields

- Standardized column names for SQL compatibility

### SES Index Construction

An SES Index was created using standardized (z-score) measures of:

- Free & Reduced Meals (%)

- English Learners (%)

- Chronic Absenteeism (%)

Higher SES Index values indicate greater socioeconomic disadvantage.

### Regression Modeling

Four model specifications were tested:

- SES Only Model

- SES + Funding Model

- District Fixed Effects Model

- Pooled Model (used for prediction)

The pooled model includes:

- SES Index

- Funding per student

- School year fixed effects

Predicted proficiency values were generated from this model.

### Performance Gap Calculation

For each district-year observation:

- Performance Gap = Actual Math Proficiency − Predicted Proficiency

District-level average gaps were used to identify:

- Top 20 Overperforming Districts

- Bottom 20 Underperforming Districts

## SQL Data Modeling

A normalized PostgreSQL schema was implemented:

- dim_district (stable district attributes)

- fact_district_performance (district-year metrics)

Analytical views include:

- District summary metrics

- Ranking views for performance gap analysis

This structure supports scalable dashboard reporting.

## Tableau Dashboard Development

<img width="1187" height="782" alt="Education Performance" src="https://github.com/user-attachments/assets/c8bade5d-0e2d-4f88-a95e-f4011dc28f5c" />

Two dashboards were created:

### Statewide Performance Overview

- Top & Bottom 20 Districts by Performance Gap

- SES Index vs Math Achievement Scatter Plot
  
<img width="1201" height="807" alt="Districts and Socioeconomics" src="https://github.com/user-attachments/assets/e25b2830-dddd-4406-bb96-dd2a86049ff1" />

### District Explorer

- District KPI summary

- Statewide ranking context

- 3-year trend: Actual vs Predicted Achievement
- 
<img width="1207" height="812" alt="District Deep Dive" src="https://github.com/user-attachments/assets/c43a1756-c641-442d-bf50-31949897fd84" />

## Key Findings

- Socioeconomic status explains a substantial portion of variation in district-level math achievement.

- Funding shows a statistically significant but modest relationship with outcomes after controlling for SES.

- Several districts consistently outperform predicted achievement levels, suggesting local institutional factors influence outcomes beyond structural conditions.

- Performance gaps vary over time, indicating district performance is dynamic rather than fixed.

## Limitations

- The analysis is observational and does not establish causality.

- The SES Index is constructed from three proxy variables and may not capture all dimensions of socioeconomic disadvantage.

- District-level aggregation masks within-district variation across schools and student subgroups.

- Additional covariates (teacher experience, class size, instructional models) were not included.

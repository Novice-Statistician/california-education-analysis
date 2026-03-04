/* 
Project: District Performance Relative to Socioeconomic Expectations
Author: Zachary Niccoli

This schema models district level academic performance relative to predicted 
achievement derived from socioeconomic index regression modeling.
*/

-- Grain: One row per (district, school_year)
-- Contains observed performance, predicted performance, and performance gap

--Staging Tables--

-- Preview staging tables
SELECT * FROM district_all LIMIT 10;
SELECT * FROM district_panel LIMIT 10;

--Dimension Tables--

-- Stores stable district attributes.
-- Separated to enforce normalization and referential integrity
DROP TABLE IF EXISTS dim_district CASCADE;

CREATE TABLE dim_district (
    cds_number VARCHAR(20) PRIMARY KEY,
    district_name VARCHAR(255) NOT NULL
);

--Populating Dimension Table--

INSERT INTO dim_district (cds_number, district_name)
SELECT DISTINCT
    cds_number,
    district_name
FROM district_panel
ON CONFLICT (cds_number) DO NOTHING;

--Fact Table: District-Year Performance Metrics--

-- Stores measurable outcomes and predictors at the district-year level
DROP TABLE IF EXISTS fact_district_performance CASCADE;

CREATE TABLE fact_district_performance (
    cds_number VARCHAR(20),
    school_year VARCHAR(9),
    ses_index FLOAT,
    funding_per_student_1000 FLOAT,
    actual_math_proficiency FLOAT,
    predicted_math FLOAT,
    performance_gap FLOAT,

    PRIMARY KEY (cds_number, school_year),
    FOREIGN KEY (cds_number) REFERENCES dim_district(cds_number)
);

--Populating Fact Table--

INSERT INTO fact_district_performance (
    cds_number,
    school_year,
    ses_index,
    funding_per_student_1000,
    actual_math_proficiency,
    predicted_math,
    performance_gap
)
SELECT
    cds_number,
    school_year,
    ses_index,
    funding_per_student_1000,
    actual_math_proficiency,
    predicted_pooled,
    gap_pooled
FROM district_panel;

--Indexing--

--Improves query performance for joins and filtering
CREATE INDEX idx_fact_cds
ON fact_district_performance (cds_number);

CREATE INDEX idx_fact_year
ON fact_district_performance (school_year);

--Analytical Views--

--Average performance metrics by district

DROP VIEW IF EXISTS district_summary;

CREATE VIEW district_summary AS
SELECT
    f.cds_number,
    d.district_name,
    ROUND(AVG(f.ses_index)::numeric, 2) AS avg_ses_index,
    ROUND(AVG(f.funding_per_student_1000)::numeric, 2) AS avg_funding,
    ROUND(AVG(f.actual_math_proficiency)::numeric, 2) AS avg_actual_math,
    ROUND(AVG(f.predicted_math)::numeric, 2) AS avg_predicted_math,
    ROUND(AVG(f.performance_gap)::numeric, 2) AS avg_performance_gap
FROM fact_district_performance f
JOIN dim_district d
    ON f.cds_number = d.cds_number
GROUP BY
    f.cds_number,
    d.district_name;

--District Performance Ranking View--

--Base ranking view
DROP VIEW IF EXISTS district_rankings;

CREATE VIEW district_rankings AS
SELECT
    *,
    RANK() OVER (ORDER BY avg_performance_gap DESC) AS gap_rank
FROM district_summary;

--Analytical Queries--

--Top 20 Overperforming Districts
SELECT *
FROM district_rankings
ORDER BY avg_performance_gap DESC
LIMIT 20;

--Bottom 20 Underperforming Districts
SELECT *
FROM district_rankings
ORDER BY avg_performance_gap ASC
LIMIT 20;


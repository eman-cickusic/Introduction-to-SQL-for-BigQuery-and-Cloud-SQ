-- ============================================================================
-- BigQuery SQL Queries for London Bikeshare Data Analysis
-- Dataset: bigquery-public-data.london_bicycles.cycle_hire
-- ============================================================================

-- Query 1: Basic SELECT - Get all end station names
-- Purpose: Retrieve all ending destinations of bikeshare rides
SELECT end_station_name 
FROM `bigquery-public-data.london_bicycles.cycle_hire`;

-- Query 2: Filtering with WHERE - Find long rides (20+ minutes)
-- Purpose: Find all bike trips that lasted 20 minutes or longer
-- Note: duration is measured in seconds (1200 seconds = 20 minutes)
SELECT * 
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
WHERE duration >= 1200;

-- Query 3: GROUP BY - Get unique starting stations
-- Purpose: Find all distinct starting locations (removes duplicates)
SELECT start_station_name 
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY start_station_name;

-- Query 4: COUNT with GROUP BY - Count rides per starting station
-- Purpose: Count how many rides begin at each starting location
SELECT start_station_name, COUNT(*) 
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY start_station_name;

-- Query 5: Using AS for aliases - Readable column names
-- Purpose: Same as Query 4 but with a more readable column name
SELECT start_station_name, COUNT(*) AS num_starts 
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY start_station_name;

-- Query 6a: ORDER BY alphabetically - Sorted by station name
-- Purpose: Get ride counts sorted alphabetically by station name
SELECT start_station_name, COUNT(*) AS num 
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY start_station_name 
ORDER BY start_station_name;

-- Query 6b: ORDER BY numerically ascending - Lowest to highest counts
-- Purpose: Get ride counts sorted from lowest to highest
SELECT start_station_name, COUNT(*) AS num 
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY start_station_name 
ORDER BY num;

-- Query 6c: ORDER BY numerically descending - Highest to lowest counts
-- Purpose: Get ride counts sorted from highest to lowest (most popular stations first)
SELECT start_station_name, COUNT(*) AS num 
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY start_station_name 
ORDER BY num DESC;

-- ============================================================================
-- EXPORT QUERIES - These are saved as CSV files for Cloud SQL import
-- ============================================================================

-- Export Query 1: Start station data for Cloud SQL
-- Purpose: Data to be exported as start_station_data.csv
-- This query finds the most popular starting stations
SELECT start_station_name, COUNT(*) AS num 
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY start_station_name 
ORDER BY num DESC;

-- Export Query 2: End station data for Cloud SQL
-- Purpose: Data to be exported as end_station_data.csv  
-- This query finds the most popular ending stations
SELECT end_station_name, COUNT(*) AS num 
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY end_station_name 
ORDER BY num DESC;

-- ============================================================================
-- ADDITIONAL ANALYSIS QUERIES
-- ============================================================================

-- Query: Find stations with more than 100,000 rides
SELECT start_station_name, COUNT(*) AS num_rides
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY start_station_name 
HAVING COUNT(*) > 100000
ORDER BY num_rides DESC;

-- Query: Average ride duration by starting station (for popular stations)
SELECT 
    start_station_name,
    COUNT(*) AS total_rides,
    AVG(duration) AS avg_duration_seconds,
    ROUND(AVG(duration)/60, 2) AS avg_duration_minutes
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY start_station_name 
HAVING COUNT(*) > 50000
ORDER BY avg_duration_seconds DESC;

-- Query: Rides by hour of day
SELECT 
    EXTRACT(HOUR FROM start_date) AS hour_of_day,
    COUNT(*) AS num_rides
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY hour_of_day 
ORDER BY hour_of_day;

-- Query: Weekend vs Weekday analysis
SELECT 
    CASE 
        WHEN EXTRACT(DAYOFWEEK FROM start_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS num_rides,
    AVG(duration) as avg_duration
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
GROUP BY day_type;

-- ============================================================================
-- DATA QUALITY CHECKS
-- ============================================================================

-- Check for null values in key columns
SELECT 
    COUNT(*) AS total_rows,
    COUNT(start_station_name) AS non_null_start_stations,
    COUNT(end_station_name) AS non_null_end_stations,
    COUNT(duration) AS non_null_durations
FROM `bigquery-public-data.london_bicycles.cycle_hire`;

-- Check duration ranges
SELECT 
    MIN(duration) AS min_duration_seconds,
    MAX(duration) AS max_duration_seconds,
    AVG(duration) AS avg_duration_seconds,
    STDDEV(duration) AS stddev_duration
FROM `bigquery-public-data.london_bicycles.cycle_hire`;

-- Find extremely long rides (potential data anomalies)
SELECT start_station_name, end_station_name, duration, start_date
FROM `bigquery-public-data.london_bicycles.cycle_hire` 
WHERE duration > 86400  -- More than 24 hours
ORDER BY duration DESC
LIMIT 10;
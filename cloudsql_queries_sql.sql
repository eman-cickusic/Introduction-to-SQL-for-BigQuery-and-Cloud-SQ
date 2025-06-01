-- ============================================================================
-- Cloud SQL MySQL Queries for London Bikeshare Data Management
-- Database: bike
-- Tables: london1 (start station data), london2 (end station data)
-- ============================================================================

-- ============================================================================
-- DATABASE AND TABLE CREATION
-- ============================================================================

-- Create the main database for bikeshare data
CREATE DATABASE bike;

-- Switch to the bike database
USE bike;

-- Create table for start station data
-- VARCHAR(255): Variable length string up to 255 characters
-- INT: Integer data type for numerical counts
CREATE TABLE london1 (
    start_station_name VARCHAR(255), 
    num INT
);

-- Create table for end station data
CREATE TABLE london2 (
    end_station_name VARCHAR(255), 
    num INT
);

-- ============================================================================
-- DATA VERIFICATION QUERIES
-- ============================================================================

-- Check if tables are created and initially empty
SELECT * FROM london1;
SELECT * FROM london2;

-- After CSV import - verify data loaded correctly
-- Check total number of records
SELECT COUNT(*) AS total_records FROM london1;
SELECT COUNT(*) AS total_records FROM london2;

-- Check first few records
SELECT * FROM london1 LIMIT 5;
SELECT * FROM london2 LIMIT 5;

-- Check for any null values
SELECT COUNT(*) AS null_station_names FROM london1 WHERE start_station_name IS NULL;
SELECT COUNT(*) AS null_station_names FROM london2 WHERE end_station_name IS NULL;

-- ============================================================================
-- DATA CLEANING OPERATIONS
-- ============================================================================

-- Remove header rows (where num = 0, typically from CSV headers)
DELETE FROM london1 WHERE num = 0;
DELETE FROM london2 WHERE num = 0;

-- Remove any potential duplicate entries
-- Note: This assumes you want to keep the record with the highest count
DELETE l1 FROM london1 l1
INNER JOIN london1 l2 
WHERE l1.start_station_name = l2.start_station_name 
AND l1.num < l2.num;

DELETE l1 FROM london2 l1
INNER JOIN london2 l2 
WHERE l1.end_station_name = l2.end_station_name 
AND l1.num < l2.num;

-- ============================================================================
-- DATA MANIPULATION EXAMPLES
-- ============================================================================

-- INSERT new test data
INSERT INTO london1 (start_station_name, num) VALUES ("test destination", 1);
INSERT INTO london2 (end_station_name, num) VALUES ("test endpoint", 1);

-- UPDATE existing records (example)
UPDATE london1 SET num = num + 1 WHERE start_station_name = "test destination";

-- ============================================================================
-- DATA ANALYSIS QUERIES
-- ============================================================================

-- Find top 10 starting stations
SELECT start_station_name, num 
FROM london1 
ORDER BY num DESC 
LIMIT 10;

-- Find top 10 ending stations  
SELECT end_station_name, num 
FROM london2 
ORDER BY num DESC 
LIMIT 10;

-- Find stations with low activity (less than 1000 rides)
SELECT start_station_name, num 
FROM london1 
WHERE num < 1000 
ORDER BY num ASC;

-- Get basic statistics for start stations
SELECT 
    COUNT(*) AS total_stations,
    SUM(num) AS total_rides,
    AVG(num) AS avg_rides_per_station,
    MIN(num) AS min_rides,
    MAX(num) AS max_rides
FROM london1;

-- Get basic statistics for end stations
SELECT 
    COUNT(*) AS total_stations,
    SUM(num) AS total_rides,
    AVG(num) AS avg_rides_per_station,
    MIN(num) AS min_rides,
    MAX(num) AS max_rides
FROM london2;

-- ============================================================================
-- ADVANCED UNION OPERATIONS
-- ============================================================================

-- Main UNION query - Combine high-traffic stations from both tables
-- This finds stations with over 100,000 rides (either as start or end points)
SELECT start_station_name AS top_stations, num 
FROM london1 
WHERE num > 100000
UNION
SELECT end_station_name, num 
FROM london2 
WHERE num > 100000
ORDER BY num DESC;

-- UNION with aliases for better readability
SELECT 
    start_station_name AS station_name, 
    num AS ride_count,
    'Start Point' AS station_type
FROM london1 
WHERE num > 50000
UNION
SELECT 
    end_station_name AS station_name, 
    num AS ride_count,
    'End Point' AS station_type
FROM london2 
WHERE num > 50000
ORDER BY ride_count DESC;

-- Find stations that appear in both top start and end station lists
SELECT 
    l1.start_station_name AS station_name,
    l1.num AS start_rides,
    l2.num AS end_rides,
    (l1.num + l2.num) AS total_rides
FROM london1 l1
INNER JOIN london2 l2 ON l1.start_station_name = l2.end_station_name
WHERE l1.num > 10000 AND l2.num > 10000
ORDER BY total_rides DESC;

-- ============================================================================
-- COMPARISON AND ANALYSIS QUERIES
-- ============================================================================

-- Compare start vs end station popularity
-- Shows stations that are much more popular as starting points vs ending points
SELECT 
    l1.start_station_name AS station_name,
    l1.num AS start_count,
    COALESCE(l2.num, 0) AS end_count,
    (l1.num - COALESCE(l2.num, 0)) AS difference
FROM london1 l1
LEFT JOIN london2 l2 ON l1.start_station_name = l2.end_station_name
WHERE l1.num > 1000
ORDER BY difference DESC
LIMIT 20;

-- Find stations that exist as end points but not start points
SELECT l2.end_station_name, l2.num
FROM london2 l2
LEFT JOIN london1 l1 ON l2.end_station_name = l1.start_station_name
WHERE l1.start_station_name IS NULL
ORDER BY l2.num DESC;

-- ============================================================================
-- DATA EXPORT QUERIES
-- ============================================================================

-- Export combined station data for analysis
SELECT 
    'START' AS type,
    start_station_name AS station_name,
    num AS ride_count
FROM london1
UNION ALL
SELECT 
    'END' AS type,
    end_station_name AS station_name,
    num AS ride_count  
FROM london2
ORDER BY ride_count DESC;

-- ============================================================================
-- MAINTENANCE AND CLEANUP QUERIES
-- ============================================================================

-- Remove test data
DELETE FROM london1 WHERE start_station_name = "test destination";
DELETE FROM london2 WHERE end_station_name = "test endpoint";

-- Backup important data before major operations
CREATE TABLE london1_backup AS SELECT * FROM london1;
CREATE TABLE london2_backup AS SELECT * FROM london2;

-- Drop backup tables when no longer needed
-- DROP TABLE london1_backup;
-- DROP TABLE london2_backup;

-- ============================================================================
-- PERFORMANCE OPTIMIZATION
-- ============================================================================

-- Add indexes for better query performance
CREATE INDEX idx_london1_station ON london1(start_station_name);
CREATE INDEX idx_london1_num ON london1(num);
CREATE INDEX idx_london2_station ON london2(end_station_name);  
CREATE INDEX idx_london2_num ON london2(num);

-- Show table information
DESCRIBE london1;
DESCRIBE london2;

-- Show index information
SHOW INDEX FROM london1;
SHOW INDEX FROM london2;
# Introduction to SQL for BigQuery and Cloud SQ

A comprehensive hands-on project demonstrating fundamental SQL operations using Google Cloud's BigQuery and Cloud SQL services with the London Bikeshare dataset.

## Video

https://youtu.be/5V4H91sYCG4

## 📋 Project Overview

This project covers the complete workflow of:
- Querying large datasets in BigQuery using fundamental SQL keywords
- Exporting query results to CSV files
- Setting up Cloud SQL instances
- Creating databases and tables in Cloud SQL
- Data manipulation and management operations

## 🎯 Learning Objectives

By completing this project, you will learn how to:
- Execute SQL queries in BigQuery to explore large datasets
- Use fundamental SQL keywords: `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `COUNT`, `AS`, `ORDER BY`
- Export subsets of data into CSV files and store them in Cloud Storage buckets
- Create and configure Cloud SQL instances
- Load CSV data into Cloud SQL tables
- Perform data manipulation operations using `DELETE`, `INSERT INTO`, and `UNION`

## 🔧 Prerequisites

- Google Cloud Platform account with billing enabled
- Basic understanding of databases and tables
- Familiarity with Google Cloud Console (recommended)
- Web browser (Chrome recommended)

## 🚀 Setup Instructions

### Step 1: Google Cloud Project Setup
1. Create a new Google Cloud project or use an existing one
2. Enable the following APIs:
   - BigQuery API
   - Cloud SQL Admin API
   - Cloud Storage API

### Step 2: Access BigQuery Console
1. Navigate to **BigQuery** in the Google Cloud Console
2. Add the public dataset:
   - Click **+ ADD**
   - Choose **Star a project by name**
   - Enter project name: `bigquery-public-data`
   - Click **STAR**

## 📊 Dataset Information

This project uses the **London Bicycles** public dataset from BigQuery:
- **Project**: `bigquery-public-data`
- **Dataset**: `london_bicycles`
- **Tables**: `cycle_hire`, `cycle_stations`
- **Data Size**: 83,434,866 rows of bikeshare trip data (2015-2017)

## 🔍 SQL Queries and Operations

### Basic SQL Operations in BigQuery

#### 1. Simple SELECT Query
```sql
SELECT end_station_name FROM `bigquery-public-data.london_bicycles.cycle_hire`;
```

#### 2. Filtering with WHERE
```sql
SELECT * FROM `bigquery-public-data.london_bicycles.cycle_hire` WHERE duration>=1200;
```

#### 3. GROUP BY for Unique Values
```sql
SELECT start_station_name FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name;
```

#### 4. COUNT with GROUP BY
```sql
SELECT start_station_name, COUNT(*) FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name;
```

#### 5. Using AS for Aliases
```sql
SELECT start_station_name, COUNT(*) AS num_starts FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name;
```

#### 6. ORDER BY Operations
```sql
-- Alphabetical order
SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY start_station_name;

-- Ascending numerical order
SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY num;

-- Descending numerical order
SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY num DESC;
```

### Export Queries for Cloud SQL

#### Start Station Data
```sql
SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY num DESC;
```

#### End Station Data
```sql
SELECT end_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY end_station_name ORDER BY num DESC;
```

## ☁️ Cloud Storage Setup

### Create Storage Bucket
1. Navigate to **Cloud Storage > Buckets**
2. Click **CREATE BUCKET**
3. Enter a unique bucket name
4. Keep default settings and click **Create**

### Upload CSV Files
1. Export query results as CSV files from BigQuery
2. Upload to your Cloud Storage bucket
3. Rename files to:
   - `start_station_data.csv`
   - `end_station_data.csv`

## 🗄️ Cloud SQL Configuration

### Create Cloud SQL Instance
```bash
# Set project ID
export PROJECT_ID=$(gcloud config get-value project)
gcloud config set project $PROJECT_ID

# Authenticate
gcloud auth login --no-launch-browser

# Connect to SQL instance
gcloud sql connect my-demo --user=root --quiet
```

### Database and Table Creation

#### Create Database
```sql
CREATE DATABASE bike;
```

#### Create Tables
```sql
USE bike;
CREATE TABLE london1 (start_station_name VARCHAR(255), num INT);
CREATE TABLE london2 (end_station_name VARCHAR(255), num INT);
```

### Data Import Process
1. In Cloud SQL console, click **IMPORT**
2. Select CSV file from Cloud Storage bucket
3. Choose **CSV** as file format
4. Select `bike` database and specify table name
5. Click **Import**

## 🛠️ Data Manipulation Operations

### DELETE Operation
```sql
DELETE FROM london1 WHERE num=0;
DELETE FROM london2 WHERE num=0;
```

### INSERT INTO Operation
```sql
INSERT INTO london1 (start_station_name, num) VALUES ("test destination", 1);
```

### UNION Operation
```sql
SELECT start_station_name AS top_stations, num FROM london1 WHERE num>100000
UNION
SELECT end_station_name, num FROM london2 WHERE num>100000
ORDER BY top_stations DESC;
```

## 📈 Key Findings

From the analysis of London bikeshare data:
- **Total trips**: 83,434,866 rides between 2015-2017
- **Long rides**: ~30% of rides lasted 20+ minutes (26,441,016 trips)
- **Starting points**: 954 distinct bikeshare starting locations
- **Ending points**: 959 distinct bikeshare ending locations
- **Top station**: "Hyde Park Corner, Hyde Park" had the highest rideshare activity

## 🔑 SQL Keywords Reference

| Keyword | Purpose |
|---------|---------|
| `SELECT` | Specify fields to retrieve from dataset |
| `FROM` | Specify source table(s) |
| `WHERE` | Filter rows based on conditions |
| `GROUP BY` | Aggregate rows with common values |
| `COUNT()` | Count number of rows |
| `AS` | Create aliases for columns/tables |
| `ORDER BY` | Sort results (ASC/DESC) |
| `CREATE` | Create databases or tables |
| `USE` | Specify database to use |
| `DELETE` | Remove rows from table |
| `INSERT INTO` | Add new rows to table |
| `UNION` | Combine results from multiple queries |

## 🏗️ Project Structure

```
sql-bigquery-cloudsql-project/
├── README.md
├── queries/
│   ├── bigquery_queries.sql
│   └── cloudsql_queries.sql
├── data/
│   ├── start_station_data.csv
│   └── end_station_data.csv
├── scripts/
│   └── setup_cloud_sql.sh
└── docs/
    └── lab_instructions.md
```

## 🚨 Important Notes

- Always use the provided lab credentials, not personal Google accounts
- Use incognito/private browser windows to avoid account conflicts
- Remember to clean up resources after completing the lab to avoid charges
- The `duration` field in the dataset is measured in seconds
- CSV exports remove column headers automatically when imported to Cloud SQL

## 🤝 Contributing

Feel free to contribute improvements to this project by:
1. Forking the repository
2. Creating a feature branch
3. Making your changes
4. Submitting a pull request

## 📄 License

This project is for educational purposes and follows Google Cloud's public dataset usage policies.

## 📞 Support

If you encounter issues:
1. Check the Google Cloud Console for error messages
2. Verify your project permissions and API enablement
3. Ensure proper authentication setup
4. Review the query syntax for typos

---

**Happy Querying!** 🎉

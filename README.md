# UK Railway Data Pipeline

This project implements a data warehouse for analyzing UK railway data, using a medallion architecture approach (bronze, silver, gold layers) in SQL Server.

## Data Sources

The source data consists of train rides transactions with information about ticket purchases, journeys, delays, and refunds.
For field descriptions, see `source/railway_data_dictionary.csv`.

## Project Structure

```
├── docs/                       # Documentation files
│   ├── railway_star_schema.pdf # Star schema design for data warehouse
│   ├── data_architecture.png   # Data architecture diagram
│   └── data_architecture.drawio # Source file for architecture diagram
├── scripts/                    # SQL scripts for data processing
│   ├── init_database.sql       # Initialize database and schemas
│   ├── bronze/                 # Bronze layer (raw data)
│   │   ├── ddl_bronze.sql      # Data definition for bronze tables
│   │   └── proc_load_bronze.sql # Procedures to load bronze layer
│   ├── silver/                 # Silver layer (cleansed data)
│   │   └── ddl_silver.sql      # Data definition for silver tables
│   ├── gold/                   # Gold layer (business models)
│   │   ├── ddl_gold.sql        # Data definition for gold tables
│   │   └── proc_load_gold.sql  # Procedures to load gold layer
│   └── data_cleaning/          # Data cleaning scripts
└── source/                     # Source data files
    ├── railway.csv             # Raw train rides dataset
    └── railway_data_dictionary.csv # Data dictionary for the dataset
```

## Getting Started

### Prerequisites

- SQL Server (2019 or newer recommended)
- SQL Server Management Studio (SSMS) or Azure Data Studio
- Python (3.10 or newer)
- Pandas,numpy,SQLAlchemy libraries

### Setup

1. Clone this repository
2. Open SQL Server Management Studio or Azure Data Studio
3. Run the `scripts/init_database.sql` script to initialize the database and schemas
4. Run the DDL scripts in each layer (bronze, silver, gold) to create the tables
5. Run the procedures to load data into each layer

## Overview

This project processes and analyzes UK railway transaction data, enabling insights into ticket sales, journey performance, delays, and refunds. The data pipeline follows a medallion architecture pattern:

1. **Bronze Layer**: Raw data ingestion from CSV files
2. **Silver Layer**: Data cleaning and transformation with Python
3. **Gold Layer**: Star schema for business analytics

## Data Warehouse Architecture

This project follows a medallion architecture pattern, which organizes data into three distinct layers:

### Bronze Layer (Raw Data)

- The initial landing zone for data ingestion
- Contains exact copies of the source data (railway.csv)
- Preserves the original data structure and values
- Provides a foundation for data lineage and auditing

### Silver Layer (Staging Area)

- Acts as a staging table that receives clean data processed by Python
- Serves as an intermediate layer between raw data and analytical models
- Contains transformed data ready for dimensional modeling
- Facilitates the transition from source-oriented to business-oriented structures

### Gold Layer (Business Models)

- Presents data in a dimensional model (star schema)
- Optimized for analytics and reporting
- Contains fact and dimension tables for analytical queries

For a visual representation of the architecture, see `docs/data_architecture.png`.

## Data Model

The project transforms raw railway data into a star schema design in the gold layer with:

- **Fact Table**:

  - `fact_railway`: A single fact table containing all transaction and journey information, including price, stations, dates, and times.

- **Dimension Tables**:
  - `dim_ticket`: Information about ticket class, type, and railcard
  - `dim_payment`: Purchase type and payment method details
  - `dim_station`: Information about departure and arrival stations
  - `dim_journey`: Journey status, delay reason, and refund request information
  - `dim_date`: Date dimension for purchase and journey dates
  - `dim_time`: Time dimension for purchase, departure, scheduled arrival, and actual arrival times

This star schema enables efficient querying for analytics across multiple dimensions, supporting business questions about ticket sales, journey performance, delays, and refunds.

For detailed schema information, refer to the `docs/railway_star_schema.pdf` document.

## Data Cleaning

The ETL process between Bronze and Silver layers leverages Python/Pandas for data transformation:

1. Data Extraction: Extract raw data from Bronze.railway using SQLAlchemy
2. Data Inspection: Examine data types, missing values, and duplicates
3. Naming Standardization: Convert column names to lowercase snake_case format
4. Format Validation: Verify date/time formats using regex pattern matching
5. Value Normalization: Standardize categorical fields (e.g., reason_for_delay)
6. Null Handling: Fill missing values in railcard and reason_for_delay fields
7. Data Loading: Insert cleaned dataset to Silver.railway via SQLAlchemy

The complete data cleaning workflow is implemented in `scripts/data_cleaning/railway_cleaning.ipynb`.

## License

Initial commit

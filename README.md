# SQL Data Warehouse Project

## Project Overview

This project focuses on building a modern SQL Data Warehouse using Microsoft SQL Server. It integrates data from CRM and ERP source systems to create a structured and reliable data foundation for analytics and reporting.

The project follows the **Medallion Architecture (Bronze, Silver, and Gold layers)** to organize data processing, transformation, and integration.

## Project Objectives

- Build a structured SQL Data Warehouse.
- Integrate data from multiple source systems (CRM and ERP).
- Perform data cleaning and standardization.
- Implement ETL processes using SQL Server.
- Transform raw data into analytics-ready datasets.
- Maintain data quality and consistency.

## Data Architecture

The project follows a three-layer Medallion Architecture:

### 1. Bronze Layer – Raw Data
- Load raw data from CRM and ERP source files.
- Use BULK INSERT for data ingestion.
- Store source data without major transformations.
- Implement stored procedures for loading data.

### 2. Silver Layer – Cleaned Data
- Remove duplicate records.
- Handle NULL values and unwanted spaces.
- Standardize categorical values.
- Perform data type conversions.
- Clean and transform source data.

### 3. Gold Layer – Business-Ready Data
- Integrate cleaned data from multiple sources.
- Apply business rules and transformations.
- Prepare structured datasets for analytical use.
- Create views for reporting and analysis.

## Technologies Used

- Microsoft SQL Server
- T-SQL (Transact-SQL)
- SQL Server Management Studio (SSMS)
- Draw.io

## Tools and Techniques

- ETL (Extract, Transform, Load)
- BULK INSERT
- Stored Procedures
- Data Cleaning
- Data Standardization
- Data Integration
- Data Quality Checks
- Medallion Architecture

## Repository Structure

```text
sql-data-warehouse-project/
│
├── datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── docs/
│
├── scripts/
│
├── tests/
│
├── .gitattributes
├── LICENSE
└── README.md
```

## Key Learnings

- Understanding SQL Data Warehouse architecture.
- Working with CRM and ERP datasets.
- Implementing ETL workflows using SQL Server.
- Writing and managing stored procedures.
- Performing data cleaning and transformation.
- Understanding data quality validation.

## Project Status

Completed the Bronze, Silver, and Gold layer implementation with SQL-based data processing and quality checks.

---

**Developed by:** Karthik V

**GitHub Repository:** https://github.com/vkarthik1301-creator/sql-data-warehouse-project

# Data Dictionary for Gold Layer

## Overview

The Gold Layer represents business-ready data for analytical and reporting purposes. It contains dimension tables and a fact table structured using a Star Schema.

## 1. gold.dim_customers

**Purpose:** Stores customer details enriched with demographic and geographic information.

| Column Name | Data Type | Description |
|---|---|---|
| customer_key | INT | Surrogate key uniquely identifying each customer. |
| customer_id | INT | Customer identifier from the source system. |
| customer_number | NVARCHAR(50) | Unique customer reference number. |
| first_name | NVARCHAR(50) | Customer's first name. |
| last_name | NVARCHAR(50) | Customer's last name. |
| country | NVARCHAR(50) | Customer's country. |
| marital_status | NVARCHAR(50) | Customer's marital status. |
| gender | NVARCHAR(50) | Customer's gender. |
| birthdate | DATE | Customer's date of birth. |

## 2. gold.dim_products

**Purpose:** Provides product information and their attributes.

| Column Name | Data Type | Description |
|---|---|---|
| product_key | INT | Surrogate key uniquely identifying each product. |
| product_id | INT | Product identifier from the source system. |
| product_number | NVARCHAR(50) | Unique product reference number. |
| product_name | NVARCHAR(50) | Name of the product. |
| category_id | NVARCHAR(50) | Identifier of the product category. |
| category | NVARCHAR(50) | Product's main category. |
| subcategory | NVARCHAR(50) | Product's subcategory. |
| maintenance | NVARCHAR(50) | Indicates whether maintenance is required. |
| cost | INT | Product cost. |
| product_line | NVARCHAR(50) | Product line classification. |
| start_date | DATE | Date when the product became available. |

## 3. gold.fact_sales

**Purpose:** Stores transactional sales data for analytical purposes.

| Column Name | Data Type | Description |
|---|---|---|
| order_number | NVARCHAR(50) | Unique sales order identifier. |
| product_key | INT | Foreign key linking to the product dimension. |
| customer_key | INT | Foreign key linking to the customer dimension. |
| order_date | DATE | Date when the order was placed. |
| shipping_date | DATE | Date when the order was shipped. |
| due_date | DATE | Payment due date. |
| sales_amount | INT | Total sales amount for the order line. |
| quantity | INT | Number of units ordered. |
| price | INT | Price per unit. |

## Sales Calculation

Sales Amount = Quantity × Price

## Data Model

The Gold Layer follows a Star Schema, where the fact table connects to the customer and product dimension tables using surrogate keys.

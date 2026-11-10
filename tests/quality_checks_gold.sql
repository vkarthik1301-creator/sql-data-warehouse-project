
/*
=============================================================================
Quality Checks: Gold Layer
=============================================================================
Purpose:
    Validate data quality, uniqueness, and referential integrity
    across Gold dimension and fact views.

Objects:
    1. gold.dim_customers
    2. gold.dim_products
    3. gold.fact_sales

Usage:
    Run after creating Gold layer views.
=============================================================================
*/

USE DataWarehouse;
GO

-- =========================================================
-- 1. Checking gold.dim_customers
-- =========================================================

-- Check uniqueness of customer_key
-- Expected: No results

SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;
GO

-- Check uniqueness of customer_id
-- Expected: No results

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
GO

-- Check NULL values in important customer columns

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END)
        AS null_customer_keys,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)
        AS null_customer_ids,
    SUM(CASE WHEN customer_number IS NULL THEN 1 ELSE 0 END)
        AS null_customer_numbers
FROM gold.dim_customers;
GO


-- =========================================================
-- 2. Checking gold.dim_products
-- =========================================================

-- Check uniqueness of product_key
-- Expected: No results

SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;
GO

-- Check uniqueness of product_number
-- Expected: No results

SELECT
    product_number,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_number
HAVING COUNT(*) > 1;
GO

-- Check NULL values in important product columns

SELECT
    COUNT(*) AS total_products,
    SUM(CASE WHEN product_key IS NULL THEN 1 ELSE 0 END)
        AS null_product_keys,
    SUM(CASE WHEN product_number IS NULL THEN 1 ELSE 0 END)
        AS null_product_numbers,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END)
        AS null_product_names
FROM gold.dim_products;
GO

-- Check products without category mapping

SELECT
    product_number,
    product_name,
    category_id,
    category,
    subcategory
FROM gold.dim_products
WHERE category IS NULL
   OR subcategory IS NULL;
GO


-- =========================================================
-- 3. Checking gold.fact_sales
-- =========================================================

-- Check total rows and NULL values

SELECT
    COUNT(*) AS total_rows,

    SUM(CASE WHEN product_key IS NULL THEN 1 ELSE 0 END)
        AS missing_product_keys,

    SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END)
        AS missing_customer_keys,

    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END)
        AS missing_order_dates,

    SUM(CASE WHEN shipping_date IS NULL THEN 1 ELSE 0 END)
        AS missing_shipping_dates,

    SUM(CASE WHEN due_date IS NULL THEN 1 ELSE 0 END)
        AS missing_due_dates

FROM gold.fact_sales;
GO

-- Check foreign key integrity: Product dimension
-- Expected: No results

SELECT
    f.order_number,
    f.product_key
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE f.product_key IS NOT NULL
  AND p.product_key IS NULL;
GO

-- Check foreign key integrity: Customer dimension
-- Expected: No results

SELECT
    f.order_number,
    f.customer_key
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
WHERE f.customer_key IS NOT NULL
  AND c.customer_key IS NULL;
GO

-- Check sales calculation consistency

SELECT
    order_number,
    sales_amount,
    quantity,
    price
FROM gold.fact_sales
WHERE sales_amount <> quantity * price;
GO


-- =========================================================
-- 4. Gold Layer Summary
-- =========================================================

SELECT
    (SELECT COUNT(*) FROM gold.dim_customers)
        AS total_customers,

    (SELECT COUNT(*) FROM gold.dim_products)
        AS total_products,

    (SELECT COUNT(*) FROM gold.fact_sales)
        AS total_sales_records;
GO

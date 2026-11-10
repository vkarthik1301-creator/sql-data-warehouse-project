
/*
=============================================================================
DDL Script: Create Gold Views
=============================================================================
Purpose:
    Creates the Gold layer dimension and fact views
    following a Star Schema design.

Views:
    1. gold.dim_customers
    2. gold.dim_products
    3. gold.fact_sales

Source:
    Silver and Bronze layers
=============================================================================
*/

USE DataWarehouse;
GO

-- =========================================================
-- 1. Dimension: gold.dim_customers
-- =========================================================

CREATE OR ALTER VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    ci.cst_marital_status AS marital_status,

    CASE
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,

    la.cntry AS country,
    ca.bdate AS birthday,
    ci.cst_create_date AS create_date

FROM silver.crm_cust_info ci

LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid

LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
GO

-- =========================================================
-- 2. Dimension: gold.dim_products
-- =========================================================

CREATE OR ALTER VIEW gold.dim_products AS

WITH ranked_products AS
(
    SELECT
        pn.*,
        ROW_NUMBER() OVER
        (
            PARTITION BY pn.prd_key
            ORDER BY
                CASE
                    WHEN pn.prd_end_dt IS NULL THEN 0
                    ELSE 1
                END,
                pn.prd_id DESC
        ) AS rn
    FROM silver.crm_prd_info pn
),
selected_products AS
(
    SELECT *
    FROM ranked_products
    WHERE rn = 1
)

SELECT
    ROW_NUMBER() OVER
    (
        ORDER BY pn.prd_start_dt, pn.prd_key
    ) AS product_key,

    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,

    CASE
        WHEN REPLACE(LEFT(b.prd_key, 5), '-', '_') = 'CO_PE'
            THEN 'CO_PD'
        ELSE REPLACE(LEFT(b.prd_key, 5), '-', '_')
    END AS category_id,

    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date

FROM selected_products pn

LEFT JOIN bronze.crm_prd_info b
    ON pn.prd_id = b.prd_id

LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON CASE
        WHEN REPLACE(LEFT(b.prd_key, 5), '-', '_') = 'CO_PE'
            THEN 'CO_PD'
        ELSE REPLACE(LEFT(b.prd_key, 5), '-', '_')
    END = pc.id;
GO

-- =========================================================
-- 3. Fact: gold.fact_sales
-- =========================================================

CREATE OR ALTER VIEW gold.fact_sales AS

SELECT
    CAST(sd.sls_ord_num AS NVARCHAR(50)) AS order_number,
    pr.product_key,
    cu.customer_key,

    TRY_CONVERT(DATE, CONVERT(CHAR(8),
        NULLIF(sd.sls_order_dt, 0)), 112) AS order_date,

    TRY_CONVERT(DATE, CONVERT(CHAR(8),
        NULLIF(sd.sls_ship_dt, 0)), 112) AS shipping_date,

    TRY_CONVERT(DATE, CONVERT(CHAR(8),
        NULLIF(sd.sls_due_dt, 0)), 112) AS due_date,

    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,

    CAST(sd.sls_price AS DECIMAL(10,2)) AS price

FROM silver.crm_sales_details sd

LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number

LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO


/*
===============================================================================
Quality Checks - Silver Layer
===============================================================================

Purpose:
    Validate data quality, consistency and accuracy in Silver tables.

Checks:
    1. NULL and Duplicate Primary Keys
    2. Unwanted Spaces
    3. Data Standardization
    4. Invalid Dates
    5. Data Consistency
===============================================================================
*/

USE DataWarehouse;
GO


/* =========================================================
   1. CRM CUSTOMER INFO
   ========================================================= */

-- Check NULL or Duplicate Customer IDs
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING cst_id IS NULL OR COUNT(*) > 1;


-- Check unwanted spaces
SELECT *
FROM silver.crm_cust_info
WHERE cst_key <> TRIM(cst_key)
   OR cst_firstname <> TRIM(cst_firstname)
   OR cst_lastname <> TRIM(cst_lastname);


-- Check standardization
SELECT DISTINCT
    cst_marital_status,
    cst_gndr
FROM silver.crm_cust_info;


/* =========================================================
   2. CRM PRODUCT INFO
   ========================================================= */

-- Check NULL or Duplicate Product IDs
SELECT
    prd_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING prd_id IS NULL OR COUNT(*) > 1;


-- Check unwanted spaces
SELECT *
FROM silver.crm_prd_info
WHERE prd_key <> TRIM(prd_key)
   OR prd_nm <> TRIM(prd_nm)
   OR prd_line <> TRIM(prd_line);


-- Check standardization
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;


-- Check invalid product dates
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt IS NOT NULL
  AND prd_end_dt IS NOT NULL
  AND prd_start_dt > prd_end_dt;


/* =========================================================
   3. CRM SALES DETAILS
   ========================================================= */

-- Check NULL or Duplicate Sales Records
SELECT
    sls_ord_num,
    sls_prd_key,
    COUNT(*) AS duplicate_count
FROM silver.crm_sales_details
GROUP BY
    sls_ord_num,
    sls_prd_key
HAVING COUNT(*) > 1;


-- Check NULL values in important columns
SELECT *
FROM silver.crm_sales_details
WHERE sls_ord_num IS NULL
   OR sls_prd_key IS NULL
   OR sls_cust_id IS NULL;


-- Check invalid sales dates
SELECT *
FROM silver.crm_sales_details
WHERE
    (sls_order_dt IS NOT NULL AND
     TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_order_dt), 112) IS NULL)
 OR (sls_ship_dt IS NOT NULL AND
     TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_ship_dt), 112) IS NULL)
 OR (sls_due_dt IS NOT NULL AND
     TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_due_dt), 112) IS NULL);


-- Check sales calculation consistency
SELECT *
FROM silver.crm_sales_details
WHERE sls_sales <> sls_quantity * sls_price;


/* =========================================================
   4. ERP CUSTOMER AZ12
   ========================================================= */

-- Check NULL or Duplicate Customer IDs
SELECT
    cid,
    COUNT(*) AS duplicate_count
FROM silver.erp_cust_az12
GROUP BY cid
HAVING cid IS NULL OR COUNT(*) > 1;


-- Check future birth dates
SELECT *
FROM silver.erp_cust_az12
WHERE bdate > CAST(GETDATE() AS DATE);


-- Check gender standardization
SELECT DISTINCT gen
FROM silver.erp_cust_az12;


/* =========================================================
   5. ERP LOCATION A101
   ========================================================= */

-- Check NULL or Duplicate Customer IDs
SELECT
    cid,
    COUNT(*) AS duplicate_count
FROM silver.erp_loc_a101
GROUP BY cid
HAVING cid IS NULL OR COUNT(*) > 1;


-- Check unwanted spaces
SELECT *
FROM silver.erp_loc_a101
WHERE cid <> TRIM(cid)
   OR cntry <> TRIM(cntry);


-- Check country standardization
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;


/* =========================================================
   6. ERP PRODUCT CATEGORY
   ========================================================= */

-- Check NULL or Duplicate Category IDs
SELECT
    id,
    COUNT(*) AS duplicate_count
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING id IS NULL OR COUNT(*) > 1;


-- Check unwanted spaces
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE id <> TRIM(id)
   OR cat <> TRIM(cat)
   OR subcat <> TRIM(subcat)
   OR maintenance <> TRIM(maintenance);


-- Check category standardization
SELECT DISTINCT
    cat,
    subcat,
    maintenance
FROM silver.erp_px_cat_g1v2;


GO
 

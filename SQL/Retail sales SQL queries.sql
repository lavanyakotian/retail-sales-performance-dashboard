-- ==========================================================
-- Project : Retail Sales Performance Dashboard
-- Author  : Lavanya
-- Tools   : PostgreSQL, SQL
--
-- Description:
-- This SQL script creates the database schema,
-- imports retail sales data into PostgreSQL,
-- and performs business analysis to support
-- the Retail Sales Performance Dashboard.
-- ==========================================================

-- ==========================================================
-- 1. CREATE TABLES
-- ==========================================================

CREATE TABLE customer_dim (
    customer_key VARCHAR(10),
    customer_name VARCHAR(100),
    contact_no VARCHAR(20),
    nid VARCHAR(20)
);

CREATE TABLE fact_table (
    payment_key VARCHAR(10),
    customer_key VARCHAR(10),
    time_key VARCHAR(10),
    item_key VARCHAR(10),
    store_key VARCHAR(10),
    quantity INT,
    unit VARCHAR(20),
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2)
);


CREATE TABLE store_dim (
    store_key VARCHAR(10),
    division VARCHAR(50),
    district VARCHAR(50),
    upazila VARCHAR(50)
);


CREATE TABLE time_dim (
    time_key VARCHAR(20),
    date_time VARCHAR(30),
    hour INTEGER,
    day INTEGER,
    week VARCHAR(20),
    month INTEGER,
    quarter VARCHAR(10),
    year INTEGER
);

CREATE TABLE trans_dim (
    payment_key VARCHAR(10),
    trans_type VARCHAR(20),
    bank_name VARCHAR(100)
);



CREATE TABLE item_dim (
    item_key VARCHAR(10),
    item_name VARCHAR(200),
    item_desc VARCHAR(200),
    unit_price DECIMAL(10,2),
    man_country VARCHAR(100),
    supplier VARCHAR(200),
    unit VARCHAR(20)
);



-- ==========================================================
-- 2. IMPORT DATA
-- ==========================================================
-- Item, Time, and Customer tables were imported using COPY.

-- Store, Transaction, and Fact tables were imported
-- using the pgAdmin Import/Export Wizard.
-- ==========================================================

-- Import Item Dimension Data
COPY item_dim
FROM 'C:\csv_data\item_dim.csv'
DELIMITER ','
CSV HEADER;

-- Import Time Dimension Data
COPY time_dim
FROM 'C:/csv_data/time_dim.csv'
DELIMITER ','
CSV HEADER;

-- Import Customer Dimension Data
COPY customer_dim
FROM 'C:/csv_data/customer_dim.csv'
DELIMITER ','
CSV HEADER;

-- ==========================================================
-- 3. BUSINESS ANALYSIS QUERIES
-- ==========================================================
-- These queries were used to analyze sales performance
-- and support the Power BI dashboard visualizations.


-- 1. Calculate Total Revenue

SELECT
    SUM(total_price) AS total_revenue
FROM fact_table;

-- ==========================================================

-- 2. Calculate Total Transactions

SELECT
    COUNT(*) AS total_transactions
FROM fact_table;
-- ==========================================================

-- 3. Calculate Total Quantity Sold

SELECT
    SUM(quantity) AS total_quantity_sold
FROM fact_table;
-- ==========================================================

-- 4. Calculate Average Order Value

SELECT
    ROUND(AVG(total_price),2) AS avg_order_value
FROM fact_table;
-- ==========================================================

-- 5. Revenue Trend by Year

SELECT
    t.year,
    SUM(f.total_price) AS revenue
FROM fact_table f
JOIN time_dim t
ON f.time_key = t.time_key
GROUP BY t.year
ORDER BY t.year;
-- ==========================================================

-- 6. Revenue by Division

SELECT
    s.division,
    SUM(f.total_price) AS revenue
FROM fact_table f
JOIN store_dim s
ON f.store_key = s.store_key
GROUP BY s.division
ORDER BY revenue DESC;
-- ==========================================================

-- 7. Top 10 Products by Revenue

SELECT
    i.item_name,
    SUM(f.total_price) AS revenue
FROM fact_table f
JOIN item_dim i
ON f.item_key = i.item_key
GROUP BY i.item_name
ORDER BY revenue DESC
LIMIT 10;
-- ==========================================================
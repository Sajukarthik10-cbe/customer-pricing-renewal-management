-- Customer Pricing & Renewal Management System
-- SQL Server compatible DDL

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(150) NOT NULL,
    industry VARCHAR(100),
    country VARCHAR(80),
    currency CHAR(3),
    customer_segment VARCHAR(30),
    account_manager VARCHAR(100)
);

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    subcategory VARCHAR(100),
    list_price_usd DECIMAL(18,2)
);

CREATE TABLE sales_representatives (
    sales_rep_id VARCHAR(20) PRIMARY KEY,
    sales_rep_name VARCHAR(100),
    country VARCHAR(80),
    region VARCHAR(80)
);

CREATE TABLE pricing_conditions (
    condition_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    condition_type VARCHAR(30),
    customer_price DECIMAL(18,2),
    discount_pct DECIMAL(8,2),
    currency CHAR(3),
    effective_date DATE,
    expiry_date DATE,
    condition_status VARCHAR(30),
    max_allowed_discount_pct DECIMAL(8,2)
);

CREATE TABLE pricing_requests (
    request_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    request_type VARCHAR(30),
    current_price DECIMAL(18,2),
    requested_price DECIMAL(18,2),
    requested_discount_pct DECIMAL(8,2),
    currency CHAR(3),
    request_date DATE,
    requested_expiry_date DATE,
    request_status VARCHAR(30)
);

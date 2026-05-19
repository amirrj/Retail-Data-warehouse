-- Create dimension tables

DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_payment;
DROP TABLE IF EXISTS dim_status;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_time;
DROP TABLE IF EXISTS dim_product;


CREATE TABLE dim_payment (
	payment_SK INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	payment_method VARCHAR(255)
);


CREATE TABLE dim_status(
	status_SK INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	status VARCHAR(255)
);


CREATE TABLE dim_customer(
	customer_SK INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	customer_id INT NOT NULL,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	email VARCHAR(255)
);


CREATE TABLE dim_store(
	store_SK INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	store_id INT NOT NULL,
	store_name VARCHAR(255),
	city VARCHAR(255),
	region VARCHAR(255),
	channel VARCHAR(255)
);


CREATE TABLE dim_date(
	date_SK INT PRIMARY KEY, 
	date_value DATE NOT NULL,
	day INT, 
	month INT, 
	year INT,
	quarter INT,
	week INT,
	month_name VARCHAR(20),
	day_name VARCHAR(20),
	day_of_week INT,
	is_weekend BOOLEAN
);


CREATE TABLE dim_time(
	time_SK INT PRIMARY KEY,
	full_time TIME NOT NULL,
	hour_24 INT NOT NULL,
	minute INT NOT NULL,
	time_period VARCHAR(255) NOT NULL -- Morning, afternoon, evening 
);


CREATE TABLE dim_product(
	product_SK INT AUTO_INCREMENT PRIMARY KEY ,
	product_id INT NOT NULL, 
	product_name VARCHAR(255) NOT NULL,
	sku VARCHAR(255) NOT NULL, 
	category VARCHAR(255) NOT NULL,
	brand VARCHAR(255) NOT NULL
);


CREATE TABLE fact_sales(
	sales_SK INT AUTO_INCREMENT PRIMARY KEY,

	-- original reference
	order_id INT NOT NULL,
	order_item_id INT NOT NULL,
	
	-- dim ref
	payment_SK INT NOT NULL,
	status_SK INT NOT NULL,
	customer_SK INT NOT NULL,
	store_SK INT NOT NULL,
	date_SK INT NOT NULL,
	time_SK INT NOT NULL,
	product_SK INT NOT NULL,
	
	-- measures
	unit_cost DECIMAL(10, 2) NOT NULL,
	unit_price DECIMAL(10, 2) NOT NULL,
	quantity INT NOT NULL,
	discount_rate FLOAT NOT NULL, 
	discount_amount DECIMAL(10, 2) NOT NULL,
	net_sales DECIMAL(10, 2) NOT NULL,
	profit DECIMAL(10, 2) NOT NULL,
	shipping_fee DECIMAL(10, 2) NOT NULL,
	order_total DECIMAL(10, 2) NOT NULL
);

-- CREATE FOREIGN KEYS

ALTER TABLE fact_sales
ADD CONSTRAINT fk_date FOREIGN KEY (date_SK) REFERENCES dim_date (date_SK),
ADD CONSTRAINT fk_time FOREIGN KEY (time_sk) REFERENCES dim_time (time_SK),
ADD CONSTRAINT fk_payment FOREIGN KEY (payment_SK) REFERENCES dim_payment(payment_SK),
ADD CONSTRAINT fk_status FOREIGN KEY (status_SK) REFERENCES dim_status(status_SK),
ADD CONSTRAINT fk_customer FOREIGN KEY (customer_SK) REFERENCES dim_customer(customer_SK),
ADD CONSTRAINT fk_store FOREIGN KEY (store_SK) REFERENCES dim_store(store_SK),
ADD CONSTRAINT fk_product FOREIGN KEY (product_SK) REFERENCES dim_product(product_SK);

-- POPULATE DIM TABLES

INSERT INTO dim_payment (payment_method)
SELECT DISTINCT payment_method
FROM RetailStaging;

INSERT INTO dim_status (status)
SELECT DISTINCT status
FROM RetailStaging;

INSERT INTO dim_customer(
customer_id,
first_name,
last_name,
email
)
SELECT DISTINCT
customer_id,
first_name,
last_name,
email
FROM RetailStaging;

INSERT INTO dim_store (
	store_id,
	store_name,
	city,
	region,
	channel
)
SELECT 
	store_id,
	store_name,
	city,
	region,
	channel
FROM RetailStaging;

INSERT INTO dim_product(
product_id, 
product_name,
sku,
category,
brand
)
SELECT DISTINCT 
product_id, 
product_name,
sku,
category,
brand
FROM RetailStaging;

-- populate date and time dims with procedure: ref - procedures.sql

CALL populate_dim_date();
CALL populate_dim_time();

-- POPULATE FACTS Table
INSERT INTO fact_sales (
order_id,
order_item_id,
date_SK,
time_SK,
payment_SK,
status_SK,
customer_SK,
store_SK,
product_SK,
unit_cost,
unit_price,
quantity,
discount_rate,
discount_amount,
net_sales,
profit,
shipping_fee,
order_total
)
SELECT DISTINCT 
rs.order_id,
rs.order_item_id,
ddate.date_SK,
dtime.time_SK,
dpayment.payment_SK,
dstatus.status_SK,
dcustomer.customer_SK,
dstore.store_SK,
dproduct.product_SK,
rs.unit_cost,
rs.unit_price,
rs.quantity,
rs.discount_rate,
rs.discount_amount,
rs.net_sales,
rs.profit,
rs.shipping_fee,
rs.order_total
FROM RetailStaging rs 
JOIN dim_date ddate ON DATE(rs.order_date) = ddate.date_value 
JOIN dim_time dtime ON TIME(rs.order_date) = dtime.full_time 	
JOIN dim_payment dpayment ON rs.payment_method = dpayment.payment_method 
JOIN dim_status dstatus ON rs.status = dstatus.status
JOIN dim_customer dcustomer ON rs.customer_id = dcustomer.customer_id 
JOIN dim_store dstore ON rs.store_id = dstore.store_id
JOIN dim_product dproduct ON rs.product_id = dproduct.product_id;


SELECT Count(*) FROM fact_sales ;


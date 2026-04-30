-- Create dimension tables

DROP TABLE IF EXISTS dim_payment;

CREATE TABLE dim_payment (
	payment_SK INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	payment_method VARCHAR(255)
);

DROP TABLE IF EXISTS dim_status;

CREATE TABLE dim_status(
	status_SK INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	status VARCHAR(255)
);

DROP TABLE IF EXISTS dim_customer;

CREATE TABLE dim_customer(
	customer_SK INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	customer_id INT NOT NULL,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	email VARCHAR(255)
);

DROP TABLE IF EXISTS dim_store;

CREATE TABLE dim_store(
	store_SK INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	store_id INT NOT NULL,
	store_name VARCHAR(255),
	country VARCHAR(255),
	city VARCHAR(255),
	region VARCHAR(255),
	channel VARCHAR(255)
);

DROP TABLE IF EXISTS dim_date;

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

DROP TABLE IF EXISTS dim_time;

CREATE TABLE dim_time(
	time_SK INT PRIMARY KEY,
	full_time TIME NOT NULL,
	hour_24 INT NOT NULL,
	minute INT NOT NULL,
	time_period VARCHAR(255) NOT NULL -- Morning, afternoon, evening 
);

DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_product(
	product_SK INT AUTO_INCREMENT PRIMARY KEY ,
	product_id INT NOT NULL, 
	product_name VARCHAR(255) NOT NULL,
	sku VARCHAR(255) NOT NULL, 
	category VARCHAR(255) NOT NULL,
	brand VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS fact_sales;

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
)

-- CREATE FOREIGN KEY
ALTER TABLE fact_sales
ADD CONSTRAINT fk_payment FOREIGN KEY (payment_SK) REFERENCES dim_payment(payment_SK),
ADD CONSTRAINT fk_status FOREIGN KEY (status_SK) REFERENCES dim_status(status_SK),
ADD CONSTRAINT fk_customer FOREIGN KEY (customer_SK) REFERENCES dim_customer(customer_SK),
ADD CONSTRAINT fk_store FOREIGN KEY (store_SK) REFERENCES dim_store(store_SK),
ADD CONSTRAINT fk_product FOREIGN KEY (product_SK) REFERENCES dim_product(product_SK);


-- populate dim tables

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
	country,
	city,
	region,
	channel
)
SELECT DISTINCT
	store_id,
	store_name,
	country,
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





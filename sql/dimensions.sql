DROP TABLE IF EXISTS dim_payment;
CREATE TABLE dim_payment (
	payment_SK INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	payment_method VARCHAR(255)
);

DROP TABLE IF EXISTS dim_status;
CREATE TABLE dim_status(
	status_ INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
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
CREATE TABLE dim_date
	date_SK INT PRIMARY KEY, 
	date_value DATE NOT NULL,
	day INT, 
	month INT, 
	year INT,
	quarter INT,
	month_name VARCHAR(20),
	day_name VARCHAR(20),
	day_of_week INT,
	is_weekend BOOLEAN
);
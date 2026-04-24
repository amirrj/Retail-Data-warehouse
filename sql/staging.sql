
-- CREATE STAGING TABLE


/*
DROP TABLE IF EXISTS RetailStaging;
CREATE TABLE RetailStaging(
	order_id INT NOT NULL PRIMARY KEY,
	order_item_id INT NOT NULL,
	order_date DATETIME NOT NULL, 
	status VARCHAR(255) NOT NULL, 
	payment_method VARCHAR(255) NOT NULL,
	customer_id INT NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	country VARCHAR(255) NOT NULL,
	store_id INT NOT NULL,
	store_name VARCHAR(255) NOT NULL,
	city VARCHAR(255) NOT NULL,
	region VARCHAR(255) NOT NULL,
	channel VARCHAR(255) NOT NULL,
	product_id INT NOT NULL,
	sku VARCHAR(255) NOT NULL,
	product_name VARCHAR(255) NOT NULL,
	category VARCHAR(255) NOT NULL,
	brand VARCHAR(255) NOT NULL,
	quantity INT NOT NULL,
	unit_cost FLOAT NOT NULL,
	unit_price FLOAT NOT NULL, 
	discount_rate FLOAT NOT NULL, 
	discount_amount FLOAT NOT NULL,
	net_sales FLOAT NOT NULL,
	profit FLOAT NOT NULL,
	shipping_fee FLOAT NOT NULL,
	order_total FLOAT NOT NULL
)*/


-- INSERT DATA INTO STAGING TABLE FROM FLAT FILE

--  Allow access to insert dta from local file
/*
SET GLOBAL local_infile = 1

TRUNCATE TABLE RetailStaging;
LOAD DATA LOCAL INFILE '/Users/amirjaved/Documents/SQL\ OLAP\ Project/retail_sales_flat.csv'
INTO TABLE RetailStaging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
*/







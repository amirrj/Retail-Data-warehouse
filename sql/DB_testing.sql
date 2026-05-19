-- check row counts

SELECT COUNT(*) from Retail_DB.RetailStaging rs; -- 7267

SELECT COUNT(*) from Retail_DB.fact_sales fs; -- 7267

--  check for missing FK Links

SELECT *
FROM fact_sales 
WHERE 
		date_SK IS NULL
	OR	time_SK IS NULL
	OR	payment_SK IS NULL
	OR	status_SK IS NULL
	OR	customer_SK IS NULL
	OR	product_SK IS NULL
	OR	store_SK IS NULL; -- 0 Missing




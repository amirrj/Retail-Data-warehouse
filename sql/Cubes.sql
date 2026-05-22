
DROP VIEW IF EXISTS sales_summary ;


-- Sales Cube

CREATE VIEW sales_summary AS SELECT 
	dd.year,dd.quarter, dd.month, dd.month_name , dd.week ,dd.day, dd.day_name, dd.day_of_week , dd.is_weekend,
	ds.store_SK ,ds.store_name, ds.region,
	dp.product_SK ,dp.product_name, dp.category, dp.brand,
	SUM(profit) AS total_profit,
	SUM(quantity) AS quantity_sold,
	SUM(discount_amount) AS total_discount_amount,
	SUM(net_sales) AS total_net_sales,
	SUM(shipping_fee) AS total_shipping_fee
FROM fact_sales fs
JOIN dim_date dd ON fs.date_SK = dd.date_SK 
JOIN dim_store ds ON fs.store_SK = ds.store_SK 
JOIN dim_product dp ON fs.product_SK = dp.product_SK 
GROUP BY dd.year,dd.quarter, dd.month, dd.month_name , dd.week ,dd.day, dd.day_name, dd.day_of_week , dd.is_weekend, ds.store_SK, ds.store_name, ds.region,dp.product_SK,dp.product_name, dp.category, dp.brand;


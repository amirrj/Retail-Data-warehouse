
DROP VIEW IF EXISTS sales_by_month ;
DROP VIEW IF EXISTS sales_by_quater ;
DROP VIEW IF EXISTS sales_by_week;
DROP VIEW IF EXISTS regional_quarterly_sales ;
DROP VIEW IF EXISTS store_monthly_sales;
DROP VIEW IF EXISTS sales_per_product;
DROP VIEW IF EXISTS sales_per_category;

-- Sales by Year, month

CREATE VIEW sales_by_month AS
SELECT
	year,
	month,
	month_name,
	SUM(profit) AS total_profit,
	SUM(quantity) AS quantity_sold,
	ROUND(AVG(discount_amount), 2) AS average_discount,
	SUM(net_sales) AS total_net_sales,
	SUM(order_total) AS total_order_total
FROM
	fact_sales fs
JOIN dim_date dd ON
	fs.date_SK = dd.date_SK
GROUP BY
	year,
	month,
	month_name
ORDER BY
	year,
	month,
	month_name;

-- Sales by Year, quarter

CREATE VIEW sales_by_quater AS
SELECT
	year,
	quarter,
	SUM(profit) AS total_profit,
	SUM(quantity) AS quantity_sold,
	ROUND(AVG(discount_amount), 2) AS average_discount,
	SUM(net_sales) AS total_net_sales,
	SUM(order_total) AS total_order_total
FROM
	fact_sales fs
JOIN dim_date dd ON
	fs.date_SK = dd.date_SK
GROUP BY
	year,
	quarter
ORDER BY
	year,
	quarter;

-- Sales by Year, week

CREATE VIEW sales_by_week AS
SELECT
	year,
	week,
	SUM(profit) AS total_profit,
	SUM(quantity) AS quantity_sold,
	ROUND(AVG(discount_amount), 2) AS average_discount,
	SUM(net_sales) AS total_net_sales,
	SUM(order_total) AS total_order_total
FROM
	fact_sales fs
JOIN dim_date dd ON
	fs.date_SK = dd.date_SK
GROUP BY
	year,
	week
ORDER BY
	year,
	week;

-- regional quarterly sales

CREATE VIEW regional_quarterly_sales AS
SELECT
	dd.year,
	dd.quarter,
	ds.region,
	SUM(profit) AS total_profit,
	SUM(quantity) AS quantity_sold,
	ROUND(AVG(discount_amount), 2) AS average_discount,
	SUM(net_sales) AS total_net_sales,
	SUM(order_total) AS total_order_total
FROM
	fact_sales fs
JOIN dim_store ds 
	ON
	fs.store_SK = ds.store_SK
JOIN dim_date dd
	ON
	fs.date_SK = dd.date_SK
GROUP BY
	dd.year,
	dd.quarter,
	ds.region
ORDER BY
	dd.year,
	dd.quarter,
	ds.region
	;

-- month sales per store

CREATE VIEW store_monthly_sales AS
SELECT
	dd.year,
	ds.store_name,
	dd.month,
	dd.month_name,
	SUM(profit) AS total_profit,
	SUM(quantity) AS quantity_sold,
	ROUND(AVG(discount_amount), 2) AS average_discount,
	SUM(net_sales) AS total_net_sales,
	SUM(order_total) AS total_order_total
FROM
	fact_sales fs
JOIN dim_store ds ON
	fs.store_SK = ds.store_SK
JOIN dim_date dd ON
	fs.date_SK = dd.date_SK
GROUP BY
	dd.year,
	dd.month,
	dd.month_name,
	ds.store_name
ORDER BY 
	dd.year,
	dd.month,
	ds.store_name
	;

-- sales per product

CREATE VIEW sales_per_product AS
SELECT dp.product_name, SUM(quantity) AS total_quantity_sold, SUM(profit) AS total_profit
FROM fact_sales fs
JOIN dim_product dp 
	ON fs.product_SK = dp.product_SK 
GROUP BY product_name
ORDER BY total_profit DESC;

-- sales per category

CREATE VIEW sales_per_category AS
SELECT dp.category, SUM(quantity) AS total_quantity_sold, SUM(profit) AS total_profit
FROM fact_sales fs
JOIN dim_product dp 
	ON fs.product_SK = dp.product_SK 
GROUP BY category
ORDER BY total_profit DESC;



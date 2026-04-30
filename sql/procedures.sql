DROP PROCEDURE IF EXISTS populate_dim_date;
DROP PROCEDURE IF EXISTS populate_dim_time;

DELIMITER $$

CREATE PROCEDURE populate_dim_date()
BEGIN
	DECLARE current_date_value DATE DEFAULT '2020-01-01';
	DECLARE end_date_value DATE DEFAULT '2030-12-31';

	WHILE current_date_value <= end_date_value DO
	
		INSERT INTO dim_date (
			date_SK,
			date_value,
			year,
			quarter,
			month,
			week,
			day,
			month_name,
			day_name,
			day_of_week,
			is_weekend
		)
		VALUES (
			DATE_FORMAT(current_date_value, '%Y%m%d'),
			current_date_value,
			YEAR(current_date_value),
			QUARTER(current_date_value),
			MONTH(current_date_value),
			WEEK(current_date_value),
			DAY(current_date_value),
			MONTHNAME(current_date_value),
			DAYNAME(current_date_value),
			DAYOFWEEK(current_date_value),
			CASE
				WHEN DAYOFWEEK(current_date_value) IN (1, 7) THEN TRUE
				ELSE FALSE
			END
		);
		
		SET current_date_value = DATE_ADD(current_date_value, INTERVAL 1 DAY);
		
	END WHILE;
	

END$$

CREATE PROCEDURE populate_dim_time()
BEGIN
	DECLARE current_time_value TIME DEFAULT '00:00:00';

	WHILE current_time_value <= '23:59:00' DO
	
	INSERT
	INTO
	dim_time(
		time_SK,
		full_time,
		hour_24,
		minute, 
		time_period
	)
VALUES(
		TIME_FORMAT(current_time_value, '%H%i'),
		current_time_value,
		HOUR(current_time_value),
		MINUTE(current_time_value),
		CASE
			WHEN HOUR(current_time_value) BETWEEN 5 AND 11 THEN 'Morning'
			WHEN HOUR(current_time_value) BETWEEN 12 AND 16 THEN 'Afternoon'
			WHEN HOUR(current_time_value) BETWEEN 17 AND 20 THEN 'Evening'
			ELSE 'Night'
		END
	);
	
	SET current_time_value = ADDTIME(current_time_value, '00:01:00');
	
	END WHILE;
	
END $$

DELIMITER ;
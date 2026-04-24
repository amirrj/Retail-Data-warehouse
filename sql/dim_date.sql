DELIMITER $$

CREATE PROCEDURE populate_dim_date()
BEGIN
	DECLARE start_date DATE DEFAULT '2020-01-01';
	DECLARE end_date DATE DEFAULT '2030-12-31';

	WHILE start_date <= end_date DO
	
		INSERT INTO dim_date VALUES (
			DATE_FORMAT(start_date, '%y%m%d'),
			start_date,
			DAY(start_date),
			MONTH(start_date),
			YEAR(start_date),
			QUARTER(start_date),
			MONTHNAME(start_date),
			DAYNAME(start_date),
			DAYOFWEEK(start_date),
			CASE
				WHEN DAYOFWEEK(start_date) IN (1,7) THEN TRUE
				ELSE FALSE 
			END
			
		);
	
	SET start_date = DATE_ADD(start_date, INTERVAL 1 DAY);
	
	END WHILE;
END$$

DELIMITER ;

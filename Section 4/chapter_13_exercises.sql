-- ------------------------- task 1
USE ap;

DROP PROCEDURE IF EXISTS task1;

DELIMITER //

CREATE PROCEDURE task1()
BEGIN
    DECLARE count_of_all_rows INT DEFAULT 0;
    
    SELECT COUNT(invoice_id)
	INTO count_of_all_rows
    FROM invoices
    WHERE invoice_total - payment_total - credit_total >= 5000;
    
    SELECT CONCAT(count_of_all_rows, ' invoices exceed $5,000') AS message;
END//

DELIMITER ;

CALL task1();

-- ------------------------- task 2
    
DROP PROCEDURE IF EXISTS task2;

DELIMITER //

CREATE PROCEDURE task2()
BEGIN
	DECLARE count_of_invoices INT DEFAULT 0;
	DECLARE sum_of_balance_due DECIMAL(9,2) DEFAULT 0;
    
    SELECT 
		COUNT(invoice_id),
		SUM(invoice_total - payment_total - credit_total)
	INTO
		count_of_invoices,
        sum_of_balance_due
	FROM invoices
    WHERE
		invoice_total - payment_total - credit_total > 0;
        
	IF sum_of_balance_due >= 30000 THEN
		SELECT 
			CONCAT('No of invoices: ',count_of_invoices) AS message1,
			CONCAT('Sum of balance due: ', sum_of_balance_due) AS message2;
	ELSE
		SELECT 'Total balance due is less than $30000' AS message;
	END IF;
END//

DELIMITER ;

CALL task2();

-- ------------------------- task 3

DROP PROCEDURE IF EXISTS task3;

DELIMITER //

CREATE PROCEDURE task3()
BEGIN
	DECLARE result INT DEFAULT 10;
    DECLARE i INT DEFAULT 1;
    
    WHILE i < 10 DO
		SET result = result * i;
        SET i = i + 1;
	END WHILE;
    
	SELECT CONCAT('The factorial of 10 is: ', result) AS message;
END//

DELIMITER ;

CALL task3();

-- ------------------------- task 4

DROP PROCEDURE IF EXISTS task4;

DELIMITER //

CREATE PROCEDURE task4()
BEGIN
	DECLARE vendor_name_var     VARCHAR(50);
	DECLARE invoice_number_var  VARCHAR(50);
	DECLARE balance_due_var     DECIMAL(9,2);

	DECLARE s                   VARCHAR(400)   DEFAULT '';
	DECLARE row_not_found       INT            DEFAULT FALSE;

	DECLARE invoices_cursor CURSOR FOR
		SELECT
			vendor_name,
            invoice_number,
            invoice_total - payment_total - credit_total AS balance_due
		FROM invoices
			JOIN vendors
				ON invoices.vendor_id = vendors.vendor_id
		WHERE invoice_total - payment_total - credit_total >= 5000
        ORDER BY invoice_total - payment_total - credit_total DESC;

	BEGIN
    DECLARE EXIT HANDLER FOR NOT FOUND
      SET row_not_found = TRUE;

    OPEN invoices_cursor;
    
    WHILE row_not_found = FALSE DO
      FETCH invoices_cursor 
      INTO vendor_name_var, invoice_number_var, balance_due_var;

      SET s = CONCAT(s, balance_due_var, '|',
                        invoice_number_var, '|',
                        vendor_name_var, '//');
    END WHILE;
    END;

    CLOSE invoices_cursor;    
  
    SELECT s AS message;
END//

DELIMITER ;

CALL task4();

-- ------------------------- task 5

DROP PROCEDURE IF EXISTS task5;

DELIMITER //

CREATE PROCEDURE task5()
BEGIN
	DECLARE invoice_id_num INT DEFAULT 1;
	DECLARE column_cannot_be_null    TINYINT   DEFAULT   FALSE;

    	DECLARE CONTINUE HANDLER FOR 1048
			SET column_cannot_be_null = TRUE;
    
		UPDATE invoices
		SET invoice_due_date = NULL
		WHERE invoice_id = invoice_id_num;

	IF column_cannot_be_null = TRUE THEN
		SELECT 'Row was not updated - column cannot be null.' AS messsage;
	ELSE
		SELECT '1 row was updated.' AS message;    
	END IF;
END//

DELIMITER ;

CALL task5();

-- ------------------------- task 6

DROP PROCEDURE IF EXISTS task6;

DELIMITER //

CREATE PROCEDURE task6()
BEGIN
   DECLARE i INT DEFAULT 1;
   DECLARE j INT;
   DECLARE divisor_found TINYINT DEFAULT TRUE;
   DECLARE s VARCHAR(400) DEFAULT '';

   WHILE i < 100 DO
      SET j = i - 1;
      WHILE j > 1 DO
        IF i % j = 0 THEN
          SET j = 1;
          SET divisor_found = TRUE;
        ELSE
          SET j = j - 1;            
        END IF;
      END WHILE;
      IF divisor_found != TRUE THEN
        SET s = CONCAT(s, i, ' | ');
      END IF;
      SET i = i + 1;
      SET divisor_found = FALSE;
   END WHILE;
    
   SELECT s AS message;
END//

DELIMITER ;

CALL task6();

-- ------------------------- task 7

DROP PROCEDURE IF EXISTS task7;

DELIMITER //

CREATE PROCEDURE task7()
BEGIN
	DECLARE vendor_name_var     VARCHAR(50);
	DECLARE invoice_number_var  VARCHAR(50);
	DECLARE balance_due_var     DECIMAL(9,2);

	DECLARE s                   VARCHAR(400)   DEFAULT '';
	DECLARE row_not_found       INT            DEFAULT FALSE;

	DECLARE invoices_cursor CURSOR FOR
		SELECT
			vendor_name,
            invoice_number,
            invoice_total - payment_total - credit_total AS balance_due
		FROM invoices
			JOIN vendors
				ON invoices.vendor_id = vendors.vendor_id
		WHERE invoice_total - payment_total - credit_total >= 5000
        ORDER BY invoice_total - payment_total - credit_total DESC;

-- --------------------------------------- 1

	BEGIN
    DECLARE EXIT HANDLER FOR NOT FOUND
      SET row_not_found = TRUE;

    OPEN invoices_cursor;
    
    SET s = CONCAT(s, '$20,000 or More: ');
    
	WHILE row_not_found = FALSE DO
      FETCH invoices_cursor 
      INTO vendor_name_var, invoice_number_var, balance_due_var;

	  IF balance_due_var >= 20000 THEN
      SET s = CONCAT(s, balance_due_var, '|',
                        invoice_number_var, '|',
                        vendor_name_var, '//');
	  END IF;
    END WHILE;
    END;

    CLOSE invoices_cursor;    

-- --------------------------------------- 2
	SET row_not_found = FALSE;

	BEGIN
    DECLARE EXIT HANDLER FOR NOT FOUND
      SET row_not_found = TRUE;

    OPEN invoices_cursor;
    
    SET s = CONCAT(s, '$10,000 to $20,000: ');
    
	WHILE row_not_found = FALSE DO
      FETCH invoices_cursor 
      INTO vendor_name_var, invoice_number_var, balance_due_var;

	  IF balance_due_var < 20000 AND balance_due_var >= 10000 THEN
      SET s = CONCAT(s, balance_due_var, '|',
                        invoice_number_var, '|',
                        vendor_name_var, '//');
	 END IF;
    END WHILE;
    END;

    CLOSE invoices_cursor;    

-- --------------------------------------- 3
	SET row_not_found = FALSE;

	BEGIN
    DECLARE EXIT HANDLER FOR NOT FOUND
      SET row_not_found = TRUE;

    OPEN invoices_cursor;
    
    SET s = CONCAT(s, '$5,000 to $10,000: ');
    
	WHILE row_not_found = FALSE DO
      FETCH invoices_cursor 
      INTO vendor_name_var, invoice_number_var, balance_due_var;

	  IF balance_due_var < 10000 AND balance_due_var >= 5000 THEN
      SET s = CONCAT(s, balance_due_var, '|',
                        invoice_number_var, '|',
                        vendor_name_var, '//');
	 END IF;
    END WHILE;
    END;

    CLOSE invoices_cursor;    

-- ---------------------------------------

    SELECT s AS message;
END//

DELIMITER ;

CALL task7();
-- example 1 ---------------------------------------

USE ap;

DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
    DECLARE sum_balance_due_var DECIMAL(9,2);
    
    SELECT SUM(invoice_total - payment_total - credit_total)
    INTO sum_balance_due_var
    FROM invoices
    WHERE vendor_id = 95;
    
    IF sum_balance_due_var > 0 THEN
        SELECT CONCAT('Balance due: $', sum_balance_due_var) AS message;
	ELSE
        SELECT 'Balance paid in full' AS message;
    END IF;
END //

DELIMITER ;

CALL test();
    
-- example 2 ---------------------------------------

DELIMITER //

CREATE PROCEDURE test2()
BEGIN
	DECLARE max_invoice_total  DECIMAL(9,2);
    DECLARE min_invoice_total  DECIMAL(9,2);
    DECLARE percent_difference DECIMAL(9,4);
    DECLARE count_invoice_id   INT;
    DECLARE vendor_id_var      INT;
    
    SET vendor_id_var = 95;
    
    SELECT
        MAX(invoice_total),
        MIN(invoice_total),
        COUNT(invoice_id)
        INTO
            max_invoice_total,
            min_invoice_total,
            count_invoice_id
	FROM
        invoices
	WHERE
		vendor_id = vendor_id_var;
        
	SET percent_difference = (max_invoice_total - min_invoice_total)/
                                min_invoice_total * 100;
	
    SELECT
		CONCAT('$', max_invoice_total) AS 'Maximum invoice',
        CONCAT('$', min_invoice_total) AS 'Minimum invoice',
        CONCAT('%', ROUND(percent_difference, 2)) AS 'Percent difference',
        count_invoice_id AS 'Number of invoices' ;
END //

DELIMITER ;

CALL test2();

-- example 3 ---------------------------------------

DELIMITER //

CREATE PROCEDURE test3()
BEGIN
	DECLARE first_invoice_due_date DATE;
    
    SELECT
    MIN(invoice_due_date)
    INTO
    first_invoice_due_date
    FROM
    invoices
    WHERE
    invoice_total - payment_total - credit_total > 0;
    
    IF first_invoice_due_date < NOW() THEN
        SELECT 'Outstanding invoices are overdue!';
	ELSEIF first_invoice_due_date = NOW() THEN
        SELECT 'Outstanding invoices are due today';
	ELSE
        SELECT 'No invoices are overdue.';
	END IF;
END //

DELIMITER ;

CALL test3();

-- example 4 ---------------------------------------

DELIMITER //

CREATE PROCEDURE test4()
BEGIN
	DECLARE terms_id_var INT;
    
    SELECT 
    terms_id 
    INTO 
    terms_id_var
    FROM 
        invoices
    WHERE
        invoice_id = 4;

    CASE terms_id_var
        WHEN 1 THEN
            SELECT 'Net due 10 days' AS Terms;
		WHEN 2 THEN
            SELECT 'Net due 10 days' AS Terms;
		WHEN 3 THEN
            SELECT 'Net due 10 days' AS Terms;
		ELSE
            SELECT 'Net due more than 30 days' AS Terms;
	END CASE;
END//

DELIMITER ;

CALL test4();

-- example 5 ---------------------------------------
-- WHILE LOOP

DELIMITER //

CREATE PROCEDURE test5a()
BEGIN
	DECLARE i INT DEFAULT 1;
    DECLARE s VARCHAR(400) DEFAULT '';
    
    WHILE i < 4 DO
		SET s = CONCAT(s, 'i=', i, ' | ');
        SET i = i + 1;
	END WHILE;
    
    SELECT s AS message;
END //

DELIMITER ;

CALL test5a();

-- REPEAT LOOP

DELIMITER //

CREATE PROCEDURE test5b()
BEGIN
	DECLARE i INT DEFAULT 1;
    DECLARE s VARCHAR(400) DEFAULT '';
    
    REPEAT
        SET s = CONCAT(s, 'i=', i, ' | ');
        SET i = i + 1;
	UNTIL i = 4
    END REPEAT;
    
    SELECT s AS message;
END //

DELIMITER ;

CALL test5b();

-- example 6 ---------------------------------------

DELIMITER //

CREATE PROCEDURE test6()
BEGIN
    DECLARE invoice_id_var        INT;
    DECLARE invoice_total_var     DECIMAL(9,2);
    DECLARE row_not_found         TINYINT DEFAULT FALSE;
    DECLARE update_count          INT DEFAULT 0;
    
    DECLARE invoices_cursor CURSOR FOR
        SELECT
            invoice_id,
            invoice_total
        FROM invoices
        WHERE
            invoice_total - payment_total - credit_total > 0;
		
	DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET row_not_found = TRUE;
        
	OPEN invoices_cursor;
    
    WHILE row_not_found = FALSE DO
        FETCH invoices_cursor INTO invoice_id_var, invoice_total_var;
        
        IF invoice_total_var > 1000 THEN
            UPDATE invoices
            SET credit_total = credit_total + (invoice_total * .1)
            WHERE invoice_id = invoice_id_var;
            SET update_count = update_count + 1;
		END IF;
	END WHILE;
    
    CLOSE invoices_cursor;
    
    SELECT CONCAT(update_count, 'row(s) updated,');
END//

DELIMITER ;

CALL test6();

-- example 7 ---------------------------------------

-- CONTINUE handler

DELIMITER //

CREATE PROCEDURE test7a()
BEGIN
	DECLARE duplicate_entry_for_key TINYINT DEFAULT FALSE;
    
    DECLARE CONTINUE HANDLER FOR 1062
    	SET duplicate_entry_for_key = TRUE;
        
	INSERT INTO general_ledger_accounts VALUES (130, 'Cash');
    
    IF duplicate_entry_for_key = TRUE THEN
    	SELECT 'Row was not interested - duplicate key encountered.' AS message;
	ELSE
    	SELECT '1 row was inserted.' AS message;
	END IF;
END//

DELIMITER ;

CALL test7a();

-- EXIT handler

DELIMITER //

CREATE PROCEDURE test7b()
BEGIN
	DECLARE duplicate_entry_for_key TINYINT DEFAULT FALSE;
    BEGIN
    	DECLARE EXIT HANDLER FOR 1062
        	SET duplicate_entry_for_key = TRUE;
		
        INSERT INTO general_ledger_accounts VALUES (130, 'Cash');
        
        SELECT '1 row was inserted.' AS message;
	END;
    
    IF duplicate_entry_for_key = TRUE THEN
    	SELECT 'Row was not inserted - duplicate key encountered.' AS message;
	END IF;
END//

DELIMITER ;

CALL test7b();

-- named condition

DELIMITER //

CREATE PROCEDURE test7c()
BEGIN
	DECLARE sql_error TINYINT DEFAULT FALSE;
    BEGIN
    	DECLARE EXIT HANDLER FOR SQLEXCEPTION
        	SET sql_error = TRUE;
            
		INSERT INTO general_ledger_accounts VALUES (130, 'Cash');
        
        SELECT '1 row was inserted' AS message;
	END;
    
    IF sql_error = TRUE THEN
    	SELECT 'Row was not inserted - SQL exception encountered' AS message;
	END IF;
END//

DELIMITER ;

CALL test7c();

   
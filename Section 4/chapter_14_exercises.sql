-- ------------------------- task 1
USE ap;

SELECT *
FROM vendors
WHERE vendor_name IN ('United Parcel Service', 'Federal Express Corporation');

SELECT *
FROM invoices
WHERE vendor_id IN (122,123);

DROP PROCEDURE IF EXISTS task14_1;

DELIMITER //

CREATE PROCEDURE task14_1()
BEGIN
    DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET sql_error = TRUE;

    START TRANSACTION;
    
    UPDATE vendors
    SET vendor_name = 'FedUP'
    WHERE vendor_id = 123;
    
    UPDATE invoices
    SET vendor_id = '123'
    WHERE vendor_id = '122';
    
    DELETE FROM vendors 
    WHERE vendor_id = '122';    
    
    IF sql_error = FALSE THEN
        COMMIT;
        SELECT 'The transaction was commited.';
	ELSE
        ROLLBACK;
        SELECT 'The transaction was rolled back.';
	END IF;
END//

DELIMITER ;

CALL task14_1();

-- ------------------------- task 2

SELECT *
FROM invoices
WHERE invoice_id = 114;

SELECT *
FROM invoice_line_items
WHERE invoice_id = 114;

DROP PROCEDURE IF EXISTS task14_2;

DELIMITER //

CREATE PROCEDURE task14_2()
BEGIN
    DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET sql_error = TRUE;

    START TRANSACTION;
    
	DELETE FROM invoice_line_items
    WHERE invoice_id = 114;

	DELETE FROM invoices
    WHERE invoice_id = 114;

    IF sql_error = FALSE THEN
        COMMIT;
        SELECT 'The transaction was commited.';
	ELSE
        ROLLBACK;
        SELECT 'The transaction was rolled back.';
	END IF;
END//

DELIMITER ;

CALL task14_2();



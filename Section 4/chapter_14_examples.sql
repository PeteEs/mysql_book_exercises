-- example 1 ---------------------------------------
-- transaction / commit and rollback

DELIMITER //

CREATE PROCEDURE ex1()
BEGIN
    DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET sql_error = TRUE;
        
	START TRANSACTION;
    
    INSERT INTO invoices VALUES
    (115, 34, 'ZXA-080', '2018-01-18', 14092.59, 0, 0, 3, '2018-04-18', NULL);
    
    INSERT INTO invoice_line_items VALUES
    (115, 1, 160, 4447.23, 'HW upgrade');
    
    INSERT INTO invoice_line_items VALUES
    (115, 1, 167, 9645.36, 'OS upgrade');
    
    IF sql_error = FALSE THEN
        COMMIT;
        SELECT 'The transaction was commited.';
	ELSE
        ROLLBACK;
        SELECT 'The transaction was rolled back.';
	END IF;
END//

DELIMITER ;

-- example 2 ---------------------------------------
-- transactions and savepoints

USE ap;

START TRANSACTION;

SAVEPOINT before_invoice;

INSERT INTO invoices VALUES
    (115, 34, 'ZXA-080', '2018-01-18', 14092.59, 0, 0, 3, '2018-04-18', NULL);
    
SAVEPOINT before_line_item_1;
    
INSERT INTO invoice_line_items VALUES
    (115, 1, 160, 4447.23, 'HW upgrade');
    
SAVEPOINT before_line_item_2;
    
INSERT INTO invoice_line_items VALUES
    (115, 1, 167, 9645.36, 'OS upgrade');

ROLLBACK TO SAVEPOINT before_line_item_2;

ROLLBACK TO SAVEPOINT before_line_item_1;

ROLLBACK TO SAVEPOINT before_invoice;

COMMIT;


















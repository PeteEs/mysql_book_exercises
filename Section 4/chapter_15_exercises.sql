-- ------------------------- task 1

USE ap;

SELECT *
FROM general_ledger_accounts;

DESCRIBE general_ledger_accounts;

DELIMITER //

CREATE PROCEDURE insert_glaccount
(
    account_number_param        INT,
    account_description_param   VARCHAR(50)
)
BEGIN
	INSERT INTO general_ledger_accounts
    VALUES (account_number_param, account_description_param);
END//

DELIMITER ;

-- Test fail: 
CALL insert_glaccount(700, 'Cash');

-- Test success: 
CALL insert_glaccount(700, 'Internet Services');

-- Clean up: 
DELETE FROM general_ledger_accounts WHERE account_number = 700;

-- ------------------------- task 2

SELECT *
FROM general_ledger_accounts;

DELIMITER //

CREATE FUNCTION test_glaccounts_description
(
    account_description_param   VARCHAR(50)
)
RETURNS TINYINT
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE account_description_var VARCHAR(50);
	
    SELECT account_description
    INTO account_description_var
    FROM general_ledger_accounts
    WHERE account_description = account_description_param;
    
    IF account_description_var IS NOT NULL THEN
        RETURN TRUE;
	ELSE
        RETURN FALSE;
	END IF;
    
    RETURN test_result;
END//

DELIMITER ;

-- Test success: 
SELECT test_glaccounts_description('Book Inventory') AS message;

-- Test fail: 
SELECT test_glaccounts_description('Fail') AS message;

-- ------------------------- task 3
/*
IF test_glaccounts_description() THEN
        SIGNAL SQLSTATE '22000'
           SET MESSAGE_TEXT = 
		       'Duplicate account description.',
		   MYSQL_ERRNO = 1062;
END IF;
*/

DELIMITER //

CREATE PROCEDURE insert_glaccount_updated
(
    account_number_param        INT,
    account_description_param   VARCHAR(50)
)
BEGIN
    IF test_glaccounts_description(account_description_param) THEN
        SIGNAL SQLSTATE '22000'
           SET MESSAGE_TEXT = 
		       'Duplicate account description.',
		   MYSQL_ERRNO = 1062;
	END IF;

	INSERT INTO general_ledger_accounts
    VALUES (account_number_param, account_description_param);
END//

DELIMITER ;

-- Test fail: 
CALL insert_glaccount_updated(700, 'Cash');

-- Test success: 
CALL insert_glaccount_updated(700, 'Internet Services');

-- Clean up: 
DELETE FROM general_ledger_accounts WHERE account_number = 700;

-- ------------------------- task 4

SELECT *
FROM terms;

DESCRIBE terms;

DROP PROCEDURE insert_terms;

DELIMITER //

CREATE PROCEDURE insert_terms
(
    terms_due_days_param       INT,
    terms_description_param    VARCHAR(50)
)
BEGIN
    DECLARE terms_description_var    VARCHAR(50);
    DECLARE sql_error TINYINT DEFAULT FALSE;
  
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
    
    -- set default values for NULL values
    IF terms_description_param IS NULL THEN
        SET terms_description_var = CONCAT('Net due ', terms_due_days_param, ' days');
	ELSE
        SET terms_description_var = terms_description_param;
    END IF;

    START TRANSACTION;

    INSERT INTO terms VALUES
    (DEFAULT, terms_description_var, terms_due_days_param);
    
    IF sql_error = FALSE THEN
        COMMIT;
	ELSE
        ROLLBACK;
    END IF;
END//

DELIMITER ;

CALL insert_terms (120, 'Net due 120 days');
CALL insert_terms (150, NULL);

SELECT *
FROM terms;

-- Clean up
DELETE FROM terms WHERE terms_id > 5;


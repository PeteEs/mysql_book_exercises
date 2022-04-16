-- example 1 ---------------------------------------

USE ap;

DELIMITER //

CREATE PROCEDURE update_invoices_credit_total_1
(
    invoice_id_param       INT,
    credit_total_param     DECIMAL(9,2)
)
BEGIN
    DECLARE sql_error TINYINT DEFAULT FALSE;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET sql_error = TRUE;
        
	START TRANSACTION;
    
    UPDATE invoices
    SET credit_total = credit_total_param
    WHERE invoice_id = invoice_id_param;
    
    IF sql_error = FALSE THEN
        COMMIT;
	ELSE
        ROLLBACK;
	END IF;
END//

DELIMITER ;

-- example 2 ---------------------------------------

DELIMITER //

CREATE PROCEDURE update_invoices_credit_total_2
(
    IN   invoice_id_param       INT,
    IN   credit_total_param     DECIMAL(9,2),
    OUT  update_count           INT
)
BEGIN
    DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET sql_error = TRUE;
        
	START TRANSACTION;
    
    UPDATE invoices
    SET credit_total = credit_total_param
    WHERE invoice_id = invoice_id_param;
    
    IF sql_error = FALSE THEN
        SET update_count = 1;
        COMMIT;
	ELSE
	    SET update_count = 0;
        ROLLBACK;
	END IF;
END//

DELIMITER ;

-- example 3 ---------------------------------------

DELIMITER //

CREATE PROCEDURE update_invoices_credit_total_3
(
    invoice_id_param       INT,
    credit_total_param     DECIMAL(9,2)
)
BEGIN
    DECLARE sql_error TINYINT DEFAULT FALSE;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET sql_error = TRUE;
        
    IF credit_total_param IS NULL THEN
       SET credit_total_param = 100;
	END IF;
        
	START TRANSACTION;
    
    UPDATE invoices
    SET credit_total = credit_total_param
    WHERE invoice_id = invoice_id_param;
    
    IF sql_error = FALSE THEN
        COMMIT;
	ELSE
        ROLLBACK;
	END IF;
END//

DELIMITER ;

-- example 4 ---------------------------------------

DELIMITER //

CREATE PROCEDURE update_invoices_credit_total_4
(
    invoice_id_param       INT,
    credit_total_param     DECIMAL(9,2)
)
BEGIN
    -- validate parameter values
    IF credit_total_param < 0 THEN
        SIGNAL SQLSTATE '22003'
           SET MESSAGE_TEXT = 
		       'The credit total column must be greater then or equal to 0.',
		   MYSQL_ERRNO = 1146;
	ELSEIF credit_total_param >= 1000 THEN
        SIGNAL SQLSTATE '22003'
           SET MESSAGE_TEXT = 
		       'The credit total column muste be less than 1000.',
		   MYSQL_ERRNO = 1146;
	END IF;
    
    -- set default values for parameters
    IF credit_total_param IS NULL THEN
       SET credit_total_param = 100;
	END IF;
    
    UPDATE invoices
    SET credit_total = credit_total_param
    WHERE invoice_id = invoice_id_param;
END//

DELIMITER ;

-- example 5 ---------------------------------------

DELIMITER //

CREATE PROCEDURE insert_invoice
(
    vendor_id_param         INT,
    invoice_number_param    VARCHAR(50),
    invoice_date_param      DATE,
    invoice_total_param     DECIMAL(9,2),
    terms_id_param          INT,
    invoice_due_date_param  DATE
)
BEGIN
    DECLARE terms_id_var           INT;
    DECLARE invoice_due_date_var   DATE;
    DECLARE terms_due_days_var     INT;
    
    -- validate parameter values
    IF credit_total_param < 0 THEN
        SIGNAL SQLSTATE '22003'
           SET MESSAGE_TEXT = 
		       'The credit total column must be a positive number.',
		   MYSQL_ERRNO = 1146;
	ELSEIF credit_total_param >= 1000000 THEN
        SIGNAL SQLSTATE '22003'
           SET MESSAGE_TEXT = 
		       'The credit total column muste be less than 1,000,000.',
		   MYSQL_ERRNO = 1146;
	END IF;
    
    -- select default value for parameters
    IF terms_id_param IS NULL THEN
        SELECT default_terms_id INTO terms_id_var
        FROM vendors
        WHERE vendor_id = vendor_id_param;
	ELSE
        SET terms_id_var = terms_id_param;
	END IF;
    
    IF invoice_due_date_param IS NULL THEN
	    SELECT terms_due_days INTO terms_due_days_var
		    FROM terms WHERE terms_id = terms_id_var;
		SELECT DATE_ADD(invoice_date_param, INTERVAL terms_due_days_var DAY)
            INTO invoice_due_date_var;
	ELSE
        SET invoice_due_date_var = invoice_due_date_param;
	END IF;
    
    -- insert into
    INSERT INTO invoices
           (vendor_id, invoice_number, invoice_date,
           invoice_total, terms_id, invoice_due_date)
	VALUES (vendor_id_param, invoice_number_param, invoice_date_param,
           invoice_total_param, terms_id_var, invoice_due_date_var);

END//

DELIMITER ;

-- example 6 ---------------------------------------
-- dynamic SQL

DELIMITER //

CREATE PROCEDURE select_invoices
(
    min_invoice_date_param    DATE,
    min_invoice_total_param   DECIMAL(9,2)
)
BEGIN
    DECLARE select_clause     VARCHAR(200);
    DECLARE where_clause      VARCHAR(200);
    
    SET select_clause = 
    "SELECT invoice_id, invoice_number,
    invoice_date, invoice_total
    FROM invoices ";
    SET where_clause = 
    "WHERE ";
    
    IF min_invoice_date_param IS NOT NULL THEN
       SET where_clause = CONCAT(where_clause,
       " invoice_date > '", min_invoice_date_param, "'");
	END IF;
    
    IF min_invoice_total_param IS NOT NULL THEN
        IF where_clause != "WHERE " THEN
            SET where_clause = CONCAT(where_clause, "AND ");
		END IF;
        SET where_clause = CONCAT(where_clause,
            "invoice_total > ", min_invoice_total_param);
	END IF;
    
    IF where_clause = "WHERE " THEN
       SET @dynamic_sql = select_clause;
	ELSE
       SET @dynamic_sql = CONCAT(select_clause, where_clause);
	END IF;
    
    PREPARE select_invoices_statement
    FROM @dynamic_sql;
    
    EXECUTE select_invoices_statement;
    
	DEALLOCATE PREPARE select_invoices_statement;
END //

DELIMITER ;

-- example 7 ---------------------------------------
-- functions

DELIMITER //

CREATE FUNCTION get_balance_due
(
    invoice_id_param   INT
)
RETURNS DECIMAL(9,2)
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE balance_due_var DECIMAL(9,2);
    
    SELECT invoice_total - payment_total - credit_total
    INTO balance_due_var
    FROM invoices
    WHERE invoice_id = invoice_id_param;
    
    RETURN balance_due_var;
END //

DELIMITER ;

-- -----------------

DELIMITER //

CREATE FUNCTION get_sum_balance_due
(
    vendor_id_param     INT
)
RETURNS DECIMAL(9,2)
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE sum_balance_due_var  DECIMAL(9,2);
    
    SELECT SUM(get_balance_due(invoice_id))
    INTO sum_balance_due_var
    FROM invoices
    WHERE vendor_id = vendor_id_param;
    
    RETURN sum_balance_due_var;
END//

DELIMITER ;












-- example 1 ---------------------------------------

DELIMITER //

CREATE TRIGGER vendors_before_update
    BEFORE UPDATE ON vendors
    FOR EACH ROW
BEGIN
    SET NEW.vendor_state = UPPER(NEW.vendor_state);
END//

DELIMITER ;

-- example 2 ---------------------------------------

USE ap;

CREATE TABLE invoices_audit
(
    vendor_id        INT           NOT NULL,
    invoice_number   VARCHAR(50)   NOT NULL,
    invoice_total    DECIMAL(9,2)  NOT NULL,
    action_type      VARCHAR(50)   NOT NULL,
    action_date      DATETIME      NOT NULL
)

DELIMITER //

CREATE TRIGGER invoices_after_insert
    AFTER INSERT ON invoices
    FOR EACH ROW
BEGIN
    INSERT INTO invoices_audit VALUES
    (NEW.vendor_id, NEW.invoice_number,
     NEW.invoice_total,'INSERTED',NOW());
END//

CREATE TRIGGER invoices_after_delete
    AFTER DELETE ON invoices
    FOR EACH ROW
BEGIN
    INSERT INTO invoices_audit VALUES
    (OLD.vendor_id, OLD.invoice_number,
     OLD.invoice_total,'DELETED',NOW());
END//

DELIMITER ;

INSERT INTO invoices VALUES
(115, 34, 'ZXA-080', '2018-02-01', 14092.59, 0, 0, 3, '2018-03-01', NULL);

DELETE FROM invoices
WHERE invoice_id = 115;

SELECT *
FROM invoices_audit;





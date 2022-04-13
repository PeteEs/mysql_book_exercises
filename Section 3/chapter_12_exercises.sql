-- --------------------------- task 1

USE  ap;

SELECT *
FROM invoices;

SELECT *
FROM vendors;

CREATE VIEW balance_due_vendors_invoices AS
SELECT
	v.vendor_name,
    i.invoice_number,
    i.invoice_total,
    i.invoice_total - i.payment_total - i.credit_total AS balance_due
FROM invoices i
	INNER JOIN vendors v
		ON v.vendor_id = i.vendor_id
WHERE
	i.invoice_total - i.payment_total - i.credit_total > 0
ORDER BY
	v.vendor_name;
    
SELECT *
FROM balance_due_vendors_invoices;

-- --------------------------- task 2

SELECT *
FROM balance_due_vendors_invoices
WHERE
	balance_due >= 1000;

-- --------------------------- task 3

CREATE VIEW open_items_summary AS
SELECT
	vendor_name,
	COUNT(*) AS open_item_count,
	SUM(i.invoice_total - i.payment_total - i.credit_total) AS open_item_total
FROM invoices i
	INNER JOIN vendors v
		ON v.vendor_id = i.vendor_id
WHERE invoice_total - credit_total - payment_total > 0
GROUP BY
	v.vendor_name
ORDER BY
	open_item_total DESC;

-- --------------------------- task 4

SELECT *
FROM open_items_summary
LIMIT 5;

-- --------------------------- task 5

SELECT *
FROM vendors;

CREATE VIEW vendor_address AS
SELECT 
	vendor_id,
    vendor_name,
    vendor_address1,
    vendor_address2
FROM vendors;

-- --------------------------- task 6

SELECT *
FROM vendor_address
WHERE vendor_id = 4;

UPDATE vendor_address
SET vendor_address1 = '1990 Westwood Blvd',
    vendor_address2 = 'Ste 260'
WHERE vendor_id = 4;


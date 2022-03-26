USE ap;

-- ----------------------- task 1

SELECT *
FROM vendors v
INNER JOIN invoices i
	ON v.vendor_id = i.vendor_id;
    
-- ----------------------- task 2

SELECT
	v.vendor_name,
    i.invoice_number,
    i.invoice_date,
    i.invoice_total - i.payment_total - i.credit_total AS balance_due
FROM vendors v
	INNER JOIN invoices i
		ON v.vendor_id = i.vendor_id
WHERE 
	i.invoice_total - i.payment_total - i.credit_total <> 0
ORDER BY
	v.vendor_name;
    
-- ----------------------- task 3

SELECT *
FROM vendors;

SELECT *
FROM general_ledger_accounts;

SELECT
	v.vendor_name,
    v.default_account_number,
    gla.account_description AS acc_description
FROM vendors v
	LEFT JOIN general_ledger_accounts gla
		ON v.default_account_number = gla.account_number
ORDER BY
	gla.account_description,
    v.vendor_name;

-- ----------------------- task 4

SELECT *
FROM vendors;

SELECT *
FROM invoices;

SELECT *
FROM invoice_line_items;

SELECT
	v.vendor_name,
    i.invoice_date,
    i.invoice_number,
    l.invoice_sequence AS li_sequence,
    l.line_item_amount AS li_amount
FROM vendors v
	INNER JOIN invoices i
		ON v.vendor_id = i.vendor_id
	INNER JOIN invoice_line_items l
		ON i.invoice_id = l.invoice_id
ORDER BY
	v.vendor_name,
    i.invoice_date,
    i.invoice_number,
    l.invoice_sequence;

-- ----------------------- task 5

SELECT DISTINCT
	v1.vendor_id,
    v1.vendor_name,
    CONCAT(v1.vendor_contact_first_name,' ',v1.vendor_contact_last_name) AS contact_name
FROM vendors v1 JOIN vendors v2
	ON v1.vendor_id <> v2.vendor_id AND 
		v1.vendor_contact_last_name = v2.vendor_contact_last_name
ORDER BY
	v1.vendor_contact_last_name;
	
-- ----------------------- task 6

SELECT
	gla.account_number,
    gla.account_description
--     l.invoice_id
FROM general_ledger_accounts gla
	LEFT JOIN invoice_line_items l
		ON gla.account_number = l.account_number
WHERE
	invoice_id IS NULL
ORDER BY
	gla.account_number;

-- ----------------------- task 7

SELECT *
FROM vendors;

SELECT
	vendor_name,
	'CA' AS vendor_state
FROM vendors
WHERE 
	vendor_state = 'CA'
UNION
SELECT
	vendor_name,
	'Outside CA' AS vendor_state
FROM vendors
WHERE 
	vendor_state <> 'CA'
ORDER BY
	vendor_name;

















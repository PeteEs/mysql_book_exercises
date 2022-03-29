USE ap;

-- ----------------------- task 1

SELECT *
FROM invoices;

SELECT
	vendor_id,
    SUM(invoice_total) AS invoice_total_per_vendor
FROM invoices
GROUP BY
	vendor_id;

-- ----------------------- task 2

SELECT *
FROM invoices;

SELECT
	vendor_id,
    SUM(payment_total) AS payment_total_per_vendor
FROM invoices
GROUP BY
	vendor_id
ORDER BY
	SUM(payment_total) DESC;

-- ----------------------- task 3

SELECT
	v.vendor_name,
    COUNT(i.invoice_id) AS invoices_count_per_vendor,
    SUM(i.invoice_total) AS invoice_total_per_vendor
FROM vendors v
	INNER JOIN invoices i
		ON v.vendor_id = i.vendor_id
GROUP BY
	v.vendor_name
ORDER BY
	COUNT(i.invoice_id) DESC;

-- ----------------------- task 4

SELECT *
FROM general_ledger_accounts;

SELECT *
FROM invoice_line_items;

SELECT 
	-- gla.account_number,
	gla.account_description,
    COUNT(ili.invoice_id) AS no_of_invoices,
    SUM(ili.line_item_amount) AS sum_of_line_item_amount
FROM general_ledger_accounts gla
	INNER JOIN	invoice_line_items ili
		ON ili.account_number = gla.account_number
GROUP BY
	gla.account_description
HAVING 
	COUNT(ili.invoice_id) > 1
ORDER BY
	SUM(ili.line_item_amount) DESC;

-- ----------------------- task 5


    










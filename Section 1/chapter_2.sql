USE ap;

SELECT vendor_name
FROM vendors;

SELECT
	COUNT(*) AS number_of_invoices,
    SUM(invoice_total) AS grand_invoice_total
FROM invoices;

-- -------------------------------------------------- ex 1

SELECT vendor_name, vendor_city, vendor_state
FROM vendors
ORDER BY vendor_name;

-- -------------------------------------------------- ex 2

SELECT COUNT(*) AS number_of_invoices,
    SUM(invoice_total - payment_total - credit_total) AS total_due
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0;

-- -------------------------------------------------- ex 3

SELECT vendor_name, vendor_city
FROM vendors
WHERE vendor_id = 34;

SELECT COUNT(*) AS number_of_invoices,
    SUM(invoice_total - payment_total - credit_total) AS total_due
FROM invoices
WHERE vendor_id = 34;


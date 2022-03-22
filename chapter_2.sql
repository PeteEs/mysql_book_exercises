USE ap;

SELECT vendor_name
FROM vendors;

SELECT
	COUNT(*) AS number_of_invoices,
    SUM(invoice_total) AS grand_invoice_total
FROM invoices;
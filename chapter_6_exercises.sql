USE ap;

-- ----------------------- task 1

SELECT *
FROM invoices;

SELECT
	vendor_id,
    SUM(invoice_total) AS invoice_total_for_vendor
FROM invoices
GROUP BY
	vendor_id;

-- ----------------------- task 2


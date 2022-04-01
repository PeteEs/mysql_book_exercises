USE ap;

-- ----------------------- task 1

SELECT DISTINCT
	vendor_name
FROM vendors
	JOIN invoices
		ON vendors.vendor_id = invoices.vendor_id
ORDER BY
	vendor_name;

SELECT DISTINCT
	vendor_name
FROM vendors
WHERE vendor_id IN
(
	SELECT vendor_id
    FROM invoices
)
ORDER BY
	vendor_name;

-- ----------------------- task 2

SELECT 
	AVG(payment_total) AS total_payment
FROM invoices
WHERE payment_total > 0;

SELECT *
FROM invoices;

SELECT
	invoice_number,
    invoice_total
FROM invoices
WHERE payment_total >
(
SELECT 
	AVG(payment_total) AS total_payment
FROM invoices
WHERE payment_total > 0
)
ORDER BY
	invoice_total DESC;

-- ----------------------- task 3

SELECT *
FROM general_ledger_accounts;

SELECT *
FROM invoice_line_items;

--  return one row for each account number that has never been assigned to any line item

SELECT
	account_number,
    account_description
FROM general_ledger_accounts gla
WHERE NOT EXISTS
	(
    SELECT *
    FROM invoice_line_items
    WHERE account_number = gla.account_number
    );

-- ----------------------- task 4

SELECT *
FROM invoices;

SELECT *
FROM vendors;

SELECT *
FROM invoice_line_items;

SELECT *
FROM invoice_line_items
WHERE
	invoice_sequence > 1;

SELECT
	v.vendor_name,
    i.invoice_id,
    ili.invoice_sequence,
    ili.line_item_amount
FROM vendors v
	JOIN invoices i
		ON v.vendor_id = i.vendor_id
	JOIN invoice_line_items ili
		ON i.invoice_id = ili.invoice_id
WHERE i.invoice_id IN
	(
	SELECT
		invoice_id
	FROM invoice_line_items
	WHERE
		invoice_sequence > 1
    )
ORDER BY 
	vendor_name, 
    i.invoice_id, 
    invoice_sequence;

-- ----------------------- task 5

SELECT *
FROM vendors;

SELECT DISTINCT
	vendor_id,
	MAX(invoice_total) AS max
FROM invoices
WHERE
	invoice_total - payment_total - credit_total > 0
GROUP BY 
	vendor_id;

-- ----

SELECT
	SUM(max) AS sum_of_max
FROM
(
	SELECT DISTINCT
		vendor_id,
		MAX(invoice_total) AS max
	FROM invoices
    WHERE
		invoice_total - payment_total - credit_total > 0
	GROUP BY 
		vendor_id
) qq;

-- ----------------------- task 6

SELECT *
FROM vendors;

SELECT
	CONCAT(vendor_state,vendor_city) AS vendor_state_city
    FROM vendors
    GROUP BY
		vendor_state_city
	HAVING
		COUNT(*) > 1;
    
SELECT
	vendor_name,
    vendor_city,
    vendor_state
FROM vendors
WHERE CONCAT(vendor_state,vendor_city) NOT IN
(
	SELECT
	CONCAT(vendor_state,vendor_city) AS vendor_state_city
    FROM vendors
    GROUP BY
		vendor_state_city
	HAVING
		COUNT(*) > 1
);

-- ----------------------- task 7

SELECT
	v.vendor_name,
    i.invoice_number,
    i.invoice_date,
    i.invoice_total,
    (
	SELECT
		MIN(invoice_date) FROM invoices
	WHERE
		vendor_id = v.vendor_id
	) AS lastest_inv
FROM vendors v
	JOIN invoices i
		ON v.vendor_id = i.vendor_id
HAVING
	i.invoice_date = lastest_inv
ORDER BY 
	vendor_name;

-- ---

SELECT
	v.vendor_name,
    i.invoice_number,
    i.invoice_date,
    i.invoice_total
FROM invoices i 
	JOIN vendors v
		ON i.vendor_id = v.vendor_id
WHERE invoice_date = 
	(
	SELECT
		MIN(invoice_date) FROM invoices
	WHERE
		vendor_id = i.vendor_id
	)
ORDER BY 
	vendor_name;

-- ----------------------- task 8

SELECT
	v.vendor_name,
    i.invoice_number,
    MIN(i.invoice_date) AS oldest_date,
    i.invoice_total
FROM vendors v
	JOIN invoices i
		ON v.vendor_id = i.vendor_id
GROUP BY
	v.vendor_name
ORDER BY 
	vendor_name;

-- -----

SELECT 
	vendor_name, 
    invoice_number,
	invoice_date, 
    invoice_total
FROM invoices i
    JOIN (
		SELECT 
			vendor_id, 
			MIN(invoice_date) AS oldest_invoice_date
		FROM invoices
		GROUP BY 
			vendor_id
    ) oi
		ON i.vendor_id = oi.vendor_id AND
			i.invoice_date = oi.oldest_invoice_date
			JOIN vendors v
				ON i.vendor_id = v.vendor_id
ORDER BY 
	vendor_name;

-- ----------------------- task 9

SELECT
	SUM(max) AS sum_of_max
FROM
(
	SELECT DISTINCT
		vendor_id,
		MAX(invoice_total) AS max
	FROM invoices
    WHERE
		invoice_total - payment_total - credit_total > 0
	GROUP BY 
		vendor_id
) qq;

-- rewrite

WITH max_totals AS
(
	SELECT DISTINCT
		vendor_id,
		MAX(invoice_total) AS max
	FROM invoices
    WHERE
		invoice_total - payment_total - credit_total > 0
	GROUP BY 
		vendor_id
)
SELECT 
	SUM(max) AS sum_of_max
FROM 
	max_totals;
    
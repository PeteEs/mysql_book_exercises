USE ap;

-- ---------------------------------------------- ex 1

SELECT * FROM invoices;

SELECT invoice_number, invoice_date, invoice_total
FROM invoices
ORDER BY invoice_total DESC;
 
SELECT invoice_id, invoice_total,
       credit_total + payment_total AS total_credits
FROM invoices
WHERE invoice_id = 17;
 
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE invoice_date BETWEEN '2014-06-01' AND '2014-06-30'
ORDER BY invoice_date;
 
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE invoice_total > 50000;

-- ---------------------------------------------- ex 2

SELECT invoice_total, payment_total, credit_total,
       invoice_total - payment_total - credit_total AS balance_due
FROM invoices;

SELECT invoice_id, 
       invoice_id + 7 * 3 AS multiply_first, 
       (invoice_id + 7) * 3 AS add_first
FROM invoices
ORDER BY invoice_id;

SELECT invoice_id, 
       invoice_id / 3 AS decimal_quotient,
       invoice_id DIV 3 AS integer_quotient,
       invoice_id % 3 AS remainder
FROM invoices
ORDER BY invoice_id;
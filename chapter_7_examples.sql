USE ap;

-- ---------------------------------------------- ex 1

SELECT 
    t1.vendor_state,
    vendor_name,
    t1.sum_of_invoices
FROM
    (
        -- invoice totals by vendor
        SELECT
            vendor_state,
            vendor_name,
            SUM(invoice_total) AS sum_of_invoices
        FROM vendors v
            JOIN invoices i
                ON v.vendor_id = i.vendor_id
        GROUP BY
            vendor_state,
            vendor_name
    ) t1
    JOIN
        (
            -- top invoice totals by state
            SELECT 
                vendor_state,
                MAX(sum_of_invoices) AS sum_of_invoices
            FROM
            (
                SELECT 
                    vendor_state,
                    vendor_name,
                    SUM(invoice_total) AS sum_of_invoices
                FROM vendors v
                    JOIN invoices i
                        ON v.vendor_id = i.vendor_id
                GROUP BY
                    vendor_state,
                    vendor_name
            ) t2
            GROUP BY
                vendor_state
    ) t3
    ON t1.vendor_state = t3.vendor_state
        AND t1.sum_of_invoices = t3.sum_of_invoices
ORDER BY
    vendor_state;

-- ---------------------------------------------- ex 2

WITH 
summary AS
(
    SELECT 
        v.vendor_state,
        v.vendor_name,
        SUM(invoice_total) AS sum_of_invoices
    FROM vendors v
        JOIN invoices i
            ON v.vendor_id = i.vendor_id
    GROUP BY
        vendor_state,
        vendor_name
),
top_in_state AS
(
    SELECT 
        vendor_state,
        MAX(sum_of_invoices) AS sum_of_invoices
    FROM summary
    GROUP BY
        vendor_state
)
SELECT 
    summary.vendor_state,
    summary.vendor_name,
    top_in_state.sum_of_invoices
FROM summary
    JOIN top_in_state
        ON summary.vendor_state = top_in_state.vendor_state
            AND summary.sum_of_invoices = top_in_state.sum_of_invoices
ORDER BY
    summary.vendor_state;


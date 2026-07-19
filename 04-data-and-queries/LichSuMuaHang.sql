SELECT
    c.full_name,
    i.invoice_datetime,
    p.product_name,
    d.quantity,
    d.unit_price,
    d.quantity*d.unit_price AS Amount
FROM CUSTOMER c
JOIN INVOICE i
ON c.customer_id=i.customer_id
JOIN INVOICE_DETAIL d
ON i.invoice_id=d.invoice_id
JOIN PRODUCT p
ON d.product_id=p.product_id
ORDER BY
    c.full_name,
    i.invoice_datetime;
    
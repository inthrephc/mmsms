SELECT TOP 1
    i.invoice_id,
    ISNULL(c.full_name,'Walk-in Customer') AS Customer,
    e.full_name AS Employee,
    SUM(d.quantity*d.unit_price) AS TotalAmount
FROM INVOICE i
LEFT JOIN CUSTOMER c
ON i.customer_id=c.customer_id
JOIN EMPLOYEE e
ON i.employee_id=e.employee_id
JOIN INVOICE_DETAIL d
ON i.invoice_id=d.invoice_id
GROUP BY
    i.invoice_id,
    c.full_name,
    e.full_name
ORDER BY TotalAmount DESC;
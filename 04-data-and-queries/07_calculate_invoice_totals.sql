USE MiniMartSalesManagement;
GO

SELECT
    i.invoice_id,
    i.invoice_datetime,
    ISNULL(c.full_name, N'Walk-in Customer') AS customer_name,
    e.full_name AS employee_name,
    CASE i.payment_method
        WHEN 1 THEN N'Cash'
        WHEN 2 THEN N'Bank transfer'
        WHEN 3 THEN N'E-wallet'
    END AS payment_method,
    SUM(d.quantity * d.unit_price) AS invoice_total
FROM dbo.INVOICE AS i
LEFT JOIN dbo.CUSTOMER AS c
    ON c.customer_id = i.customer_id
INNER JOIN dbo.EMPLOYEE AS e
    ON e.employee_id = i.employee_id
INNER JOIN dbo.INVOICE_DETAIL AS d
    ON d.invoice_id = i.invoice_id
GROUP BY
    i.invoice_id,
    i.invoice_datetime,
    c.full_name,
    e.full_name,
    i.payment_method
ORDER BY
    i.invoice_datetime,
    i.invoice_id;

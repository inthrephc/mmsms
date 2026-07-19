USE MiniMartSalesManagement;
GO

;WITH InvoiceTotals AS
(
    SELECT
        i.invoice_id,
        i.invoice_datetime,
        ISNULL(c.full_name, N'Walk-in Customer') AS customer_name,
        e.full_name AS employee_name,
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
        e.full_name
)
SELECT TOP (1) WITH TIES
    invoice_id,
    invoice_datetime,
    customer_name,
    employee_name,
    invoice_total
FROM InvoiceTotals
ORDER BY invoice_total DESC;

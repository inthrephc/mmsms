USE MiniMartSalesManagement;
GO

SELECT
    CAST(i.invoice_datetime AS DATE) AS sales_date,
    COUNT(DISTINCT i.invoice_id) AS invoice_count,
    SUM(d.quantity * d.unit_price) AS daily_revenue
FROM dbo.INVOICE AS i
INNER JOIN dbo.INVOICE_DETAIL AS d
    ON d.invoice_id = i.invoice_id
GROUP BY CAST(i.invoice_datetime AS DATE)
ORDER BY sales_date;

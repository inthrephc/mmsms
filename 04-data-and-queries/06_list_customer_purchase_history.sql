USE MiniMartSalesManagement;
GO

DECLARE @customer_id INT = 1;

SELECT
    c.customer_id,
    c.full_name AS customer_name,
    i.invoice_id,
    i.invoice_datetime,
    p.product_name,
    d.quantity,
    d.unit_price AS historical_unit_price,
    d.quantity * d.unit_price AS line_total
FROM dbo.CUSTOMER AS c
INNER JOIN dbo.INVOICE AS i
    ON i.customer_id = c.customer_id
INNER JOIN dbo.INVOICE_DETAIL AS d
    ON d.invoice_id = i.invoice_id
INNER JOIN dbo.[PRODUCT] AS p
    ON p.product_id = d.product_id
WHERE c.customer_id = @customer_id
ORDER BY
    i.invoice_datetime,
    i.invoice_id,
    p.product_name;

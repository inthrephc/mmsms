USE MiniMartSalesManagement;
GO

SELECT TOP (5)
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(d.quantity) AS total_quantity_sold,
    SUM(d.quantity * d.unit_price) AS sales_amount
FROM dbo.[PRODUCT] AS p
INNER JOIN dbo.CATEGORY AS c
    ON c.category_id = p.category_id
INNER JOIN dbo.INVOICE_DETAIL AS d
    ON d.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    c.category_name
ORDER BY
    total_quantity_sold DESC,
    p.product_id;

USE MiniMartSalesManagement;
GO

SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.unit_price,
    p.stock_quantity
FROM dbo.[PRODUCT] AS p
INNER JOIN dbo.CATEGORY AS c
    ON c.category_id = p.category_id
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.INVOICE_DETAIL AS d
    WHERE d.product_id = p.product_id
)
ORDER BY p.product_name;

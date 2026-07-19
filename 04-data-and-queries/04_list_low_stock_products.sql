USE MiniMartSalesManagement;
GO

DECLARE @stock_threshold INT = 50;

SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.stock_quantity,
    p.unit_price
FROM dbo.[PRODUCT] AS p
INNER JOIN dbo.CATEGORY AS c
    ON c.category_id = p.category_id
WHERE p.stock_quantity <= @stock_threshold
ORDER BY
    p.stock_quantity,
    p.product_name;

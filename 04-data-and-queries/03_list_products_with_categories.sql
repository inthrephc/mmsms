USE MiniMartSalesManagement;
GO

SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.unit_price,
    p.stock_quantity,
    c.description AS category_description
FROM dbo.[PRODUCT] AS p
INNER JOIN dbo.CATEGORY AS c
    ON c.category_id = p.category_id
ORDER BY
    c.category_name,
    p.product_name;

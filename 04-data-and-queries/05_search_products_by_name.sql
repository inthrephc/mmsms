USE MiniMartSalesManagement;
GO

DECLARE @keyword NVARCHAR(150) = N'Milk';

SELECT
    product_id,
    product_name,
    unit_price,
    stock_quantity
FROM dbo.[PRODUCT]
WHERE product_name LIKE N'%' + @keyword + N'%'
ORDER BY product_name;

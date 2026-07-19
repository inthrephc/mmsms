USE MiniMartSalesManagement;
GO

SELECT
    product_id,
    product_name,
    unit_price
FROM dbo.[PRODUCT]
WHERE unit_price >
(
    SELECT AVG(unit_price)
    FROM dbo.[PRODUCT]
)
ORDER BY
    unit_price DESC,
    product_name;

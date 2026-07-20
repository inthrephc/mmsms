CREATE OR ALTER FUNCTION dbo.fn_CalculateProductStockValue
(
	@product_id INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN
	DECLARE @stock_value DECIMAL(18,2);

 	SELECT
     	@stock_value =
         	CAST(unit_price AS DECIMAL(18,2))
         	* CAST(stock_quantity AS DECIMAL(18,2))
 	FROM dbo.PRODUCT
 	WHERE product_id = @product_id;

 	RETURN COALESCE(@stock_value, 0);
END;

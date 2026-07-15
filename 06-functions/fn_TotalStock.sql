CREATE FUNCTION fn_TotalStock()
RETURNS INT
AS
BEGIN
    DECLARE @TotalStock INT;

    SELECT @TotalStock = SUM(stock_quantity)
    FROM PRODUCT;

    RETURN ISNULL(@TotalStock, 0);
END;
GO
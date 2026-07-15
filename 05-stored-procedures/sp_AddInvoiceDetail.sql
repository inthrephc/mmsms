CREATE OR ALTER PROCEDURE dbo.sp_AddInvoiceDetail
    @invoice_id INT,
    @product_id INT,
    @quantity INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables
    DECLARE @current_stock INT;
    DECLARE @unit_price DECIMAL(10,2);

    -- 1. Validate quantity
    IF @quantity <= 0 OR @quantity IS NULL
    BEGIN
        RAISERROR(N'Quantity must be greater than 0.', 16, 1);
        RETURN;
    END

    -- 2. Check if invoice exists
    IF NOT EXISTS (SELECT 1 FROM dbo.INVOICE WHERE invoice_id = @invoice_id)
    BEGIN
        RAISERROR(N'Invoice does not exist.', 16, 1);
        RETURN;
    END

    -- 3. Get product stock and price
    SELECT @current_stock = stock_quantity, @unit_price = unit_price
    FROM dbo.[PRODUCT]
    WHERE product_id = @product_id;

    IF @current_stock IS NULL
    BEGIN
        RAISERROR(N'Product does not exist.', 16, 1);
        RETURN;
    END

    -- 4. Check if stock is sufficient
    IF @current_stock < @quantity
    BEGIN
        RAISERROR(N'Insufficient stock.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        -- Begin transaction
        BEGIN TRANSACTION;
        
        -- 5. Insert or update invoice detail
        IF EXISTS (SELECT 1 FROM dbo.INVOICE_DETAIL WHERE invoice_id = @invoice_id AND product_id = @product_id)
        BEGIN
            UPDATE dbo.INVOICE_DETAIL
            SET quantity = quantity + @quantity
            WHERE invoice_id = @invoice_id AND product_id = @product_id;
        END
        ELSE
        BEGIN
            INSERT INTO dbo.INVOICE_DETAIL (invoice_id, product_id, quantity, unit_price)
            VALUES (@invoice_id, @product_id, @quantity, @unit_price);
        END

        COMMIT TRANSACTION;
        PRINT N'Invoice detail added successfully!';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
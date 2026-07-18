/* ============================================================
   TEST 1: INSERT
   Mục tiêu:
   - Tạo hóa đơn mới.
   - Thêm 1 sản phẩm.
   - Trigger tự động giảm tồn kho.
   ============================================================ */

-- Xem tồn kho trước
SELECT product_id, product_name, stock_quantity
FROM dbo.PRODUCT
WHERE product_id = 1;

DECLARE @InvoiceID INT;

-- Tạo hóa đơn
INSERT INTO dbo.INVOICE
(
    customer_id,
    employee_id,
    invoice_datetime,
    payment_method
)
VALUES
(
    NULL,
    1,
    SYSDATETIME(),
    1
);

SET @InvoiceID = SCOPE_IDENTITY();

PRINT 'Invoice ID =';
PRINT @InvoiceID;

-- Thêm sản phẩm
INSERT INTO dbo.INVOICE_DETAIL
(
    invoice_id,
    product_id,
    quantity,
    unit_price
)
VALUES
(
    @InvoiceID,
    1,
    5,
    4500
);

-- Xem tồn kho sau
SELECT product_id, product_name, stock_quantity
FROM dbo.PRODUCT
WHERE product_id = 1;
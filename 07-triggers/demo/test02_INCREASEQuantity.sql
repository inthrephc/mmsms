/* ============================================================
   TEST 2: UPDATE TĂNG QUANTITY
   quantity: 5 -> 8
   Trigger chỉ giảm thêm 3.
   ============================================================ */

-- Kiểm tra trước khi update
SELECT *
FROM dbo.INVOICE_DETAIL
WHERE invoice_id = 6
  AND product_id = 1;

SELECT product_id, product_name, stock_quantity
FROM dbo.PRODUCT
WHERE product_id = 1;

-- Update
UPDATE dbo.INVOICE_DETAIL
SET quantity = 8
WHERE invoice_id = 6
  AND product_id = 1;

-- Kiểm tra sau update
SELECT *
FROM dbo.INVOICE_DETAIL
WHERE invoice_id = 6
  AND product_id = 1;

SELECT product_id, product_name, stock_quantity
FROM dbo.PRODUCT
WHERE product_id = 1;
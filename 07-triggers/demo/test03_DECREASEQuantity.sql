/* ============================================================
   TEST 3: UPDATE GIẢM QUANTITY
   quantity: 8 -> 2
   Trigger hoàn lại 6 sản phẩm vào kho.
   ============================================================ */

-- Kiểm tra trước update
SELECT *
FROM dbo.INVOICE_DETAIL
WHERE invoice_id = 6
  AND product_id = 1;

SELECT product_id, product_name, stock_quantity
FROM dbo.PRODUCT
WHERE product_id = 1;

-- Update
UPDATE dbo.INVOICE_DETAIL
SET quantity = 2
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
/* ============================================================
   TRIGGER: trg_UpdateStock_AfterInsertInvoiceDetail
   Mục đích:
     - Ứng với BR21: "Khi một invoice detail được insert,
       stock_quantity của product tương ứng phải giảm"
     - Ứng với dòng "Giảm tồn kho sau khi bán" trong bảng
       SQL Implementation Notes -> dùng trigger AFTER INSERT
       trên bảng INVOICE_DETAIL

   Lưu ý:
     - Trigger xử lý được cả trường hợp insert nhiều dòng
       cùng lúc (bulk insert) bằng cách GROUP BY product_id
       trên bảng ảo "inserted", tránh sai sót khi 1 invoice
       có nhiều invoice detail được insert trong 1 câu lệnh.
     - Nếu update khiến stock_quantity < 0, ràng buộc
       CHECK (stock_quantity >= 0) (BR20) trên bảng PRODUCT
       sẽ tự động rollback toàn bộ transaction (bao gồm cả
       insert vào INVOICE_DETAIL), đảm bảo tồn kho không
       bao giờ âm.
   ============================================================ */

CREATE TRIGGER trg_UpdateStock_AfterInsertInvoiceDetail
ON INVOICE_DETAIL
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Gom số lượng bán theo từng sản phẩm
    -- (phòng trường hợp 1 câu lệnh insert nhiều dòng cho cùng 1 product_id)
    ;WITH SoldQty AS (
        SELECT
            product_id,
            SUM(quantity) AS total_qty
        FROM inserted
        GROUP BY product_id
    )

    UPDATE p
    SET p.stock_quantity = p.stock_quantity - s.total_qty
    FROM PRODUCT p
    INNER JOIN SoldQty s
        ON p.product_id = s.product_id;
END;
GO

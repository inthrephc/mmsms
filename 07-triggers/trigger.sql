/* ============================================================
   Trigger: giảm/điều chỉnh stock_quantity của PRODUCT khi INVOICE_DETAIL
   được insert hoặc update (BR13, BR21).
   Dùng delta = inserted.quantity - deleted.quantity (không dùng nguyên
   inserted.quantity) để tính đúng cho cả INSERT lẫn UPDATE quantity.
   Không xử lý DELETE (ngoài phạm vi đề bài).
   BR20 (stock_quantity >= 0) đã có CHECK constraint trên PRODUCT lo.
   ============================================================ */

CREATE OR ALTER TRIGGER dbo.trg_AdjustStock_AfterInvoiceDetailChange
ON dbo.INVOICE_DETAIL
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    ;WITH Delta AS (
        SELECT
            COALESCE(i.product_id, d.product_id) AS product_id,
            SUM(ISNULL(i.quantity, 0)) - SUM(ISNULL(d.quantity, 0)) AS qty_delta
        FROM inserted i
        FULL OUTER JOIN deleted d
            ON i.invoice_id = d.invoice_id
           AND i.product_id = d.product_id
        GROUP BY COALESCE(i.product_id, d.product_id)
    )

    UPDATE p
    SET p.stock_quantity = p.stock_quantity - dl.qty_delta
    FROM dbo.[PRODUCT] p
    INNER JOIN Delta dl
        ON p.product_id = dl.product_id
    WHERE dl.qty_delta <> 0;
END;
GO

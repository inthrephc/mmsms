# Step 7 — Trigger: `trg_AdjustStock_AfterInvoiceDetailChange`

## 1. Trigger này dùng để làm gì?

Tự động cập nhật `stock_quantity` trong bảng `PRODUCT` mỗi khi bảng `INVOICE_DETAIL` có thay đổi (bán hàng mới hoặc sửa số lượng đã bán), để tồn kho luôn khớp với số lượng thực tế đã bán ra — không cần ứng dụng phải tự tay chạy thêm 1 câu `UPDATE PRODUCT` riêng.

## 2. Vì sao cần trigger này? (bám theo requirements)

| Rule | Nội dung | Trigger xử lý thế nào |
| --- | --- | --- |
| **BR21** | Khi một invoice detail được insert, `stock_quantity` của product tương ứng phải giảm. | `AFTER INSERT` → trừ kho theo số lượng vừa bán. |
| **BR13** | Sản phẩm không được trùng trong cùng hóa đơn; nếu khách mua thêm, phải **tăng `quantity`** của dòng cũ thay vì tạo dòng mới. | Vì "mua thêm" là 1 câu `UPDATE quantity`, nên trigger phải bắt luôn `AFTER UPDATE`, không chỉ `INSERT`. |
| **BR20** | `stock_quantity` không được âm. | Không xử lý trong trigger — đã có sẵn `CHECK (stock_quantity >= 0)` trên bảng `PRODUCT`. Nếu trigger update khiến kho âm, SQL Server tự chặn và rollback. |
| SQL Implementation Notes | "Giảm tồn kho sau khi bán → dùng trigger" | Đây chính là lý do chọn trigger thay vì để tầng ứng dụng tự trừ kho — đảm bảo dù insert bằng cách nào (app, script, tay) thì kho vẫn luôn được cập nhật. |

## 3. Vì sao AFTER UPDATE lại quan trọng — ví dụ cụ thể

Giả sử khách đã mua 3 gói mì (`quantity = 3`), sau đó quay lại mua thêm 2 gói nữa. Theo BR13, hệ thống **không** tạo dòng `INVOICE_DETAIL` mới, mà **update** dòng cũ: `quantity` từ 3 → 5.

Nếu trigger chỉ có `AFTER INSERT`, thao tác `UPDATE` này sẽ không kích hoạt trigger → tồn kho không bị trừ thêm 2 gói vừa bán → **sai lệch tồn kho**. Đây là lý do trigger phải là `AFTER INSERT, UPDATE`.

## 4. Vì sao không được lấy nguyên `inserted.quantity` để trừ kho?

Đây là lỗi dễ mắc nhất khi viết trigger kiểu này. Ở SQL Server, khi có `UPDATE`, hai bảng ảo `inserted` và `deleted` đều có dữ liệu:

- `deleted` chứa **giá trị cũ** (trước khi update).
- `inserted` chứa **giá trị mới** (sau khi update).

Nếu trigger chỉ lấy `inserted.quantity` rồi trừ thẳng vào kho, thì với ví dụ trên (`quantity` 3 → 5):

- Cách làm **sai**: trừ kho thêm 5 → tổng cộng đã trừ 3 (lúc insert ban đầu) + 5 (lúc update) = 8, trong khi khách chỉ mua tổng cộng 5 gói. **Kho bị trừ dư 3.**
- Cách làm **đúng**: chỉ trừ thêm phần **chênh lệch (delta)** = 5 (mới) − 3 (cũ) = 2. Tổng cộng đã trừ 3 + 2 = 5, khớp với số lượng khách mua thực tế.

Vì vậy trigger phải tính:

```
delta = SUM(inserted.quantity) − SUM(deleted.quantity)
```

- Khi là **INSERT**: `deleted` rỗng nên `delta = quantity mới − 0 = quantity mới` → đúng như trừ kho bình thường.
- Khi là **UPDATE**: `delta` chính là phần chênh lệch cần trừ thêm (hoặc hoàn lại nếu khách trả bớt hàng, delta âm → kho được cộng lại).

## 5. Giải thích từng phần trong code

```sql
CREATE OR ALTER TRIGGER dbo.trg_AdjustStock_AfterInvoiceDetailChange
ON dbo.INVOICE_DETAIL
AFTER INSERT, UPDATE
```
- `CREATE OR ALTER`: cho phép chạy lại script nhiều lần (khi sửa trigger) mà không cần `DROP TRIGGER` trước — tránh lỗi "trigger already exists" khi test đi test lại.
- `ON dbo.INVOICE_DETAIL`: trigger gắn vào bảng này vì đây là bảng ghi nhận sản phẩm bán ra.
- `AFTER INSERT, UPDATE`: trigger sẽ tự chạy sau khi câu lệnh `INSERT` hoặc `UPDATE` trên `INVOICE_DETAIL` thực thi thành công. Không có `DELETE` vì đề bài không yêu cầu hoàn kho khi xóa hóa đơn (nằm ngoài phạm vi assignment).

```sql
SET NOCOUNT ON;
```
- Tắt thông báo kiểu "(1 row affected)" trả về sau mỗi câu lệnh bên trong trigger. Đây là quy ước chuẩn khi viết trigger/procedure ở SQL Server — tránh gây nhiễu hoặc lỗi ở phần mềm client khi nhận nhiều thông báo "rows affected" không cần thiết.

```sql
SET XACT_ABORT ON;
```
- Đảm bảo: nếu có bất kỳ lỗi runtime nào xảy ra trong trigger (ví dụ update làm vi phạm `CHECK (stock_quantity >= 0)`), toàn bộ transaction — bao gồm cả câu `INSERT`/`UPDATE` gốc vào `INVOICE_DETAIL` — sẽ **chắc chắn bị hủy (rollback)** hoàn toàn, không để sót dữ liệu nửa vời (ví dụ có invoice detail nhưng kho không được trừ tương ứng).

```sql
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
```
Đây là phần cốt lõi của trigger, tính `qty_delta` (chênh lệch số lượng) cho từng sản phẩm:

- **`inserted`** và **`deleted`**: 2 bảng ảo tạm thời mà SQL Server tự tạo ra bên trong trigger.
  - Với `INSERT`: `inserted` chứa các dòng vừa được thêm, `deleted` rỗng.
  - Với `UPDATE`: `inserted` chứa giá trị mới, `deleted` chứa giá trị cũ của các dòng bị sửa.
- **`FULL OUTER JOIN ... ON i.invoice_id = d.invoice_id AND i.product_id = d.product_id`**: ghép dòng mới và dòng cũ của **cùng một invoice detail** lại với nhau (dựa theo khóa chính composite `(invoice_id, product_id)`), để so sánh "trước và sau". Dùng `FULL OUTER JOIN` thay vì `INNER JOIN` vì khi là INSERT thuần túy, bên `deleted` sẽ không có dòng khớp — nếu dùng `INNER JOIN` thì các dòng INSERT sẽ bị loại mất hoàn toàn, kho sẽ không được trừ.
- **`COALESCE(i.product_id, d.product_id)`**: vì `FULL OUTER JOIN` có thể khiến `i.product_id` hoặc `d.product_id` bị `NULL` (khi không có dòng khớp bên kia), hàm `COALESCE` sẽ lấy giá trị khác NULL đầu tiên, đảm bảo luôn xác định đúng sản phẩm nào cần cập nhật, dù dòng đó đến từ `inserted` hay `deleted`.
- **`SUM(ISNULL(i.quantity, 0)) - SUM(ISNULL(d.quantity, 0))`**: tính tổng số lượng mới trừ tổng số lượng cũ. `ISNULL(..., 0)` để tránh phép trừ ra `NULL` khi 1 trong 2 bên không có dữ liệu (trường hợp INSERT hoặc chuẩn hóa dữ liệu thiếu). Kết quả là `qty_delta` — phần chênh lệch cần điều chỉnh vào kho.
- **`GROUP BY`**: gom nhóm theo sản phẩm, để xử lý đúng khi 1 câu lệnh `INSERT`/`UPDATE` tác động đến **nhiều dòng cùng lúc** (bulk insert/update) — ví dụ 1 hóa đơn có nhiều sản phẩm được thêm chung 1 lệnh `INSERT ... VALUES (...), (...), (...)`.

```sql
UPDATE p
SET p.stock_quantity = p.stock_quantity - dl.qty_delta
FROM dbo.[PRODUCT] p
INNER JOIN Delta dl
    ON p.product_id = dl.product_id
WHERE dl.qty_delta <> 0;
```
- Lấy kết quả từ CTE `Delta` ở trên, join với bảng `PRODUCT` theo `product_id`, rồi trừ `qty_delta` vào `stock_quantity` hiện tại.
  - `qty_delta` dương (bán thêm) → kho giảm.
  - `qty_delta` âm (trả bớt hàng, giảm quantity) → kho được cộng lại (vì trừ đi 1 số âm).
- **`WHERE dl.qty_delta <> 0`**: bỏ qua các sản phẩm không có thay đổi thực sự về số lượng (ví dụ `UPDATE` chỉ đổi `unit_price` mà không đổi `quantity` thì `qty_delta = 0`, không cần động vào kho) — tránh update thừa không cần thiết.
- Nếu phép trừ này khiến `stock_quantity < 0`, ràng buộc `CHECK (stock_quantity >= 0)` (BR20) đã khai báo sẵn trên bảng `PRODUCT` sẽ tự động chặn câu `UPDATE` này lại, và nhờ `SET XACT_ABORT ON` ở trên, toàn bộ transaction (kể cả `INSERT`/`UPDATE` gốc vào `INVOICE_DETAIL`) sẽ bị rollback hoàn toàn.

## 6. Những gì trigger **không** làm (và vì sao)

- **Không xử lý `DELETE`**: nếu hủy 1 dòng `INVOICE_DETAIL` (ví dụ hủy hóa đơn), kho sẽ **không** tự động được hoàn lại. Đây là quyết định thiết kế có chủ đích vì đề bài (BR21, SQL Implementation Notes) chỉ yêu cầu xử lý khi bán hàng (insert), không yêu cầu nghiệp vụ hoàn kho khi hủy hóa đơn.
- **Không tự kiểm tra tồn kho âm bằng `IF` / `RAISERROR`**: việc này đã được đảm bảo bởi `CHECK (stock_quantity >= 0)` trên bảng `PRODUCT` (BR20). Trigger chỉ tập trung đúng 1 việc: tính và áp dụng đúng phần chênh lệch cần trừ/cộng vào kho.

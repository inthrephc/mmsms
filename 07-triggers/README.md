# Trigger Demo

Thư mục `demo/` chứa các kịch bản kiểm thử trigger điều chỉnh tồn kho khi dữ liệu trong `INVOICE_DETAIL` được thêm mới hoặc cập nhật.

## 1. Cấu trúc thư mục

```text
07-triggers/
├── demo/
│   ├── test01_INSERT.sql
│   ├── test02_INCREASEQuantity.sql
│   └── test03_DECREASEQuantity.sql
├── trigger.sql
└── README.md
```

## 2. Thứ tự thực thi

1. Chạy script tạo cơ sở dữ liệu và dữ liệu mẫu.
2. Chạy file `trigger.sql`.
3. Chạy các file demo theo thứ tự:

```text
test01_INSERT.sql
test02_INCREASEQuantity.sql
test03_DECREASEQuantity.sql
```

Các test sau sử dụng dữ liệu được tạo hoặc cập nhật từ test trước, vì vậy không nên thay đổi thứ tự chạy.

## 3. Mục tiêu

Trigger tự động điều chỉnh số lượng tồn kho của sản phẩm khi:

- Thêm sản phẩm vào chi tiết hóa đơn.
- Tăng số lượng sản phẩm trong chi tiết hóa đơn.
- Giảm số lượng sản phẩm trong chi tiết hóa đơn.

Trigger không xử lý thao tác `DELETE`.

## 4. Thông tin trigger

| Mục | Nội dung |
|---|---|
| Tên trigger | `dbo.trg_AdjustStock_AfterInvoiceDetailChange` |
| Bảng áp dụng | `dbo.INVOICE_DETAIL` |
| Thời điểm chạy | `AFTER INSERT, UPDATE` |
| Business rule | Khi thêm mới hoặc thay đổi số lượng sản phẩm trong chi tiết hóa đơn, tồn kho của sản phẩm phải được điều chỉnh tương ứng. Trigger sử dụng phần chênh lệch `delta = inserted.quantity - deleted.quantity` để xử lý đúng cho cả `INSERT` và `UPDATE`. |
| Bảng bị ảnh hưởng | Đọc dữ liệu từ `inserted`, `deleted`; cập nhật cột `stock_quantity` của bảng `dbo.PRODUCT`. |
| Xử lý lỗi | Trigger không tự dùng `THROW`. Nếu tồn kho sau cập nhật nhỏ hơn `0`, CHECK constraint `CK_PRODUCT_STOCK_QUANTITY` sẽ chặn câu lệnh và rollback toàn bộ thao tác. |
| Cách kiểm tra | Chạy lần lượt ba file trong thư mục `demo`, sau đó so sánh dữ liệu trước và sau trong `INVOICE_DETAIL` và `PRODUCT`. |

## 5. Logic xử lý

Trigger tính phần chênh lệch số lượng:

```text
qty_delta = inserted.quantity - deleted.quantity
```

### INSERT

Khi thêm mới một dòng:

```text
deleted.quantity = 0
qty_delta = inserted.quantity
```

Tồn kho được cập nhật:

```text
stock_quantity = stock_quantity - inserted.quantity
```

### UPDATE tăng quantity

Ví dụ:

```text
quantity: 5 → 8
qty_delta = 8 - 5 = 3
```

Trigger chỉ trừ thêm `3` sản phẩm khỏi kho.

### UPDATE giảm quantity

Ví dụ:

```text
quantity: 8 → 3
qty_delta = 3 - 8 = -5
```

Tồn kho được cập nhật:

```text
stock_quantity = stock_quantity - (-5)
```

Tức là hoàn lại `5` sản phẩm vào kho.

## 6. Nội dung các file demo

### `test01_INSERT.sql`

Mục tiêu:

- Tạo hóa đơn mới.
- Thêm một dòng vào `INVOICE_DETAIL`.
- Kiểm tra tồn kho giảm đúng bằng số lượng bán.

Kết quả mong đợi:

```text
stock sau = stock trước - quantity
```

### `test02_INCREASEQuantity.sql`

Mục tiêu:

- Tăng `quantity` của một dòng chi tiết hóa đơn.
- Kiểm tra trigger chỉ trừ phần chênh lệch.

Kết quả mong đợi:

```text
stock sau = stock trước - (quantity mới - quantity cũ)
```

### `test03_DECREASEQuantity.sql`

Mục tiêu:

- Giảm `quantity` của một dòng chi tiết hóa đơn.
- Kiểm tra trigger hoàn lại phần số lượng đã giảm vào kho.

Kết quả mong đợi:

```text
stock sau = stock trước + (quantity cũ - quantity mới)
```

## 7. Xử lý dữ liệu không hợp lệ

Bảng `PRODUCT` có CHECK constraint:

```sql
CHECK (stock_quantity >= 0)
```

Nếu một thao tác làm tồn kho âm, SQL Server sẽ báo lỗi:

```text
The UPDATE statement conflicted with the CHECK constraint
"CK_PRODUCT_STOCK_QUANTITY".
```

Khi đó:

- Câu `INSERT` hoặc `UPDATE` trên `INVOICE_DETAIL` bị hủy.
- Thay đổi trên `PRODUCT` bị hủy.
- Dữ liệu giữ nguyên như trước khi thực hiện câu lệnh.

Nếu một câu lệnh cập nhật nhiều dòng và chỉ có một dòng làm tồn kho âm, toàn bộ câu lệnh vẫn bị rollback.

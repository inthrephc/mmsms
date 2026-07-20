# Function — `fn_TotalStock`

## 1. Mục đích

`fn_TotalStock` tính tổng số lượng tồn kho hiện tại của tất cả product trong hệ thống. Function này có thể được dùng trong báo cáo tổng quan kho hoặc dashboard quản lý.

## 2. Thông tin function

| Nội dung | Mô tả |
| --- | --- |
| Tên function | `dbo.fn_TotalStock` |
| File SQL | `fn_TotalStock.sql` |
| Tham số đầu vào | Không có |
| Kiểu trả về | `INT` |
| Giá trị trả về | Tổng của `PRODUCT.stock_quantity`; trả về `0` nếu bảng `PRODUCT` chưa có dữ liệu |
| Bảng sử dụng | `PRODUCT` |
| Công thức | `SUM(stock_quantity)` |
| Tác động dữ liệu | Chỉ đọc dữ liệu, không insert, update hoặc delete |

## 3. Cách chạy

1. Chạy `03-relational-model/create_database.sql` để tạo database và bảng `PRODUCT`.
2. Chạy `fn_TotalStock.sql` để tạo function.
3. Gọi function bằng câu lệnh sau:

```sql
SELECT dbo.fn_TotalStock() AS total_stock_quantity;
```

Với dữ liệu mẫu mặc định của Step 3, kết quả mong đợi là `660`.

## 4. Ví dụ sử dụng trong báo cáo

```sql
SELECT
    dbo.fn_TotalStock() AS total_stock_quantity,
    COUNT(*) AS product_count
FROM dbo.[PRODUCT];
```

Function luôn phản ánh `stock_quantity` hiện tại. Nếu trigger hoặc stored procedure điều chỉnh tồn kho sau một giao dịch bán hàng, kết quả của function cũng thay đổi tương ứng.

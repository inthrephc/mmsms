# Function — `fn_TotalStock`

## 1a. Mục đích

`fn_TotalStock` tính tổng số lượng tồn kho hiện tại của tất cả product trong hệ thống. Function này có thể được dùng trong báo cáo tổng quan kho hoặc dashboard quản lý.

## 2a. Thông tin function

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

## 3a. Cách chạy

1. Chạy `03-relational-model/create_database.sql` để tạo database và bảng `PRODUCT`.
2. Chạy `fn_TotalStock.sql` để tạo function.
3. Gọi function bằng câu lệnh sau:

```sql
SELECT dbo.fn_TotalStock() AS total_stock_quantity;
```

Với dữ liệu mẫu mặc định của Step 3, kết quả mong đợi là `660`.

## 4a. Ví dụ sử dụng trong báo cáo

```sql
SELECT
    dbo.fn_TotalStock() AS total_stock_quantity,
    COUNT(*) AS product_count
FROM dbo.[PRODUCT];
```

Function luôn phản ánh `stock_quantity` hiện tại. Nếu trigger hoặc stored procedure điều chỉnh tồn kho sau một giao dịch bán hàng, kết quả của function cũng thay đổi tương ứng.

## 1b. Tên function
`dbo.fn_CalculateProductStockValue`

## 2b. File SQL
`fn_CalculateProductStockValue.sql`

## 3b. Mục đích
Function dùng để tính tổng giá trị hàng tồn kho của một sản phẩm trong hệ thống quản lý bán hàng cửa hàng tiện lợi.

## 4b. Tham số đầu vào
- `@product_id INT`: mã của sản phẩm cần tính giá trị tồn kho.

## 5b. Kiểu dữ liệu trả về
- `DECIMAL(18,2)`: tổng giá trị hàng tồn kho của sản phẩm.
- Function trả về `0` nếu không tìm thấy product_id.

## 6b. Công thức xử lý
`stock_value = unit_price × stock_quantity`

## 7b. Bảng được sử dụng
- `dbo.PRODUCT`
- Các cột sử dụng: `product_id`, `unit_price`, `stock_quantity`.

## 8b. Cách sử dụng
```sql
SELECT dbo.fn_CalculateProductStockValue(1) AS stock_value;
```

Ví dụ hiển thị giá trị tồn kho của tất cả sản phẩm:
```sql
SELECT
	product_id,
	product_name,
	unit_price,
 	stock_quantity,
     dbo.fn_CalculateProductStockValue(product_id) AS stock_value
FROM dbo.PRODUCT;
```

# Trigger

## 1. Mục đích

Thư mục này dùng để lưu một trigger bắt buộc của bài assignment.

Trigger nên thể hiện một business rule tự động của hệ thống Mini Mart Sales Management System, đặc biệt là các rule cần chạy ngay khi dữ liệu trong bảng thay đổi.

## 4. Nội dung trigger cần mô tả

Sau khi viết trigger, README cần ghi rõ:

| Mục cần ghi | Nội dung cần mô tả |
| ----------- | ------------------ |
| Tên trigger | Tên chính xác trong SQL. |
| Bảng áp dụng | Trigger được tạo trên bảng nào. |
| Thời điểm chạy | `AFTER INSERT`, `AFTER UPDATE`, `INSTEAD OF DELETE`, hoặc loại trigger khác. |
| Business rule | Quy tắc nghiệp vụ trigger đảm bảo. |
| Bảng bị ảnh hưởng | Trigger đọc hoặc cập nhật những bảng nào. |
| Xử lý lỗi | Nếu dữ liệu không hợp lệ thì trigger báo lỗi hoặc rollback như thế nào. |
| Cách kiểm tra | Các bước chạy SQL để chứng minh trigger hoạt động đúng. |

## 5. Demo cần có trong SQL

File `trigger.sql` nên có phần demo gồm:

1. Xem dữ liệu trước khi trigger chạy.
2. Thực hiện lệnh `INSERT`, `UPDATE` hoặc `DELETE` làm trigger được kích hoạt.
3. Xem dữ liệu sau khi trigger chạy.
4. Nếu có kiểm tra lỗi, thêm một trường hợp dữ liệu sai để chứng minh trigger chặn được.

Ví dụ cách trình bày demo:

```sql
-- 1. Check stock before insert
SELECT product_id, product_name, stock_quantity
FROM PRODUCT
WHERE product_id = 1;

-- 2. Insert invoice detail to activate trigger
INSERT INTO INVOICE_DETAIL (invoice_id, product_id, quantity, unit_price)
VALUES (1, 1, 2, 10000);

-- 3. Check stock after insert
SELECT product_id, product_name, stock_quantity
FROM PRODUCT
WHERE product_id = 1;
```

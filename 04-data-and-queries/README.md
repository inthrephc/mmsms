# Step 4 — Dữ liệu mẫu và câu truy vấn demo

## 1. Mục đích

Thư mục này chứa các câu truy vấn minh họa cách khai thác dữ liệu của Mini Mart Sales Management System. Dữ liệu mẫu được tạo sẵn trong file `03-relational-model/create_database.sql`, vì vậy không cần chạy thêm file insert trong thư mục này.

## 2. Điều kiện và thứ tự chạy

1. Chạy `03-relational-model/create_database.sql` để tạo database, bảng và dữ liệu mẫu.
2. Chọn chạy từng file SQL trong thư mục này. Các query chỉ đọc dữ liệu nên có thể chạy độc lập với nhau.

Dữ liệu mẫu gồm 4 category, 8 product, 3 customer, 3 employee, 5 invoice và 11 invoice detail. Trong đó có cả invoice của registered customer và walk-in customer.

## 3. Danh sách câu truy vấn

| File | Mục đích | Kết quả mong đợi với dữ liệu mẫu |
| --- | --- | --- |
| `DanhSachNhanVien.sql` | Liệt kê thông tin nhân viên. | Trả về 3 nhân viên. |
| `DanhSachSanPham.sql` | Liệt kê product kèm category, giá và tồn kho. | Trả về 8 product, được sắp xếp theo tên product. |
| `SanPhamDuoi50.sql` | Lọc các product có tồn kho dưới 50. | Trả về `Milk Bread` và `Orange Juice 1L`. |
| `LichSuMuaHang.sql` | Hiển thị lịch sử mua hàng của registered customer. | Trả về product, quantity, giá bán lịch sử và thành tiền; walk-in invoice không xuất hiện vì không có customer record. |
| `HoaDonLonNhat.sql` | Tìm invoice có tổng tiền cao nhất. | Invoice 3 có tổng tiền `144000.00`, do `Pham Quoc Huy` tạo cho `Tran Bao Long`. |
| `TopSanPham.sql` | Tìm 5 product có tổng quantity bán cao nhất. | `Instant Noodles` đứng đầu với 15 đơn vị đã bán. |

## 4. Kỹ thuật SQL được minh họa

| Kỹ thuật | File sử dụng |
| --- | --- |
| `SELECT` và sắp xếp `ORDER BY` | `DanhSachNhanVien.sql`, `DanhSachSanPham.sql` |
| Lọc dữ liệu bằng `WHERE` | `SanPhamDuoi50.sql` |
| Nối bảng bằng `JOIN` và `LEFT JOIN` | `DanhSachSanPham.sql`, `LichSuMuaHang.sql`, `HoaDonLonNhat.sql`, `TopSanPham.sql` |
| Xử lý walk-in customer bằng `ISNULL` | `HoaDonLonNhat.sql` |
| Tính toán `quantity * unit_price` | `LichSuMuaHang.sql`, `HoaDonLonNhat.sql` |
| Gom nhóm `GROUP BY` và tổng hợp `SUM` | `HoaDonLonNhat.sql`, `TopSanPham.sql` |
| Giới hạn kết quả bằng `TOP` | `HoaDonLonNhat.sql`, `TopSanPham.sql` |

## 5. Ghi chú

- Tổng tiền invoice và thành tiền từng dòng được tính từ `quantity * unit_price`; chúng không được lưu thành cột riêng trong database.
- Các query doanh thu sử dụng `INVOICE_DETAIL.unit_price`, vì đây là giá tại thời điểm bán và có thể khác giá hiện tại trong `PRODUCT`.
- Các file query dùng dữ liệu mẫu từ Step 3. Nếu dữ liệu bị thay đổi, số lượng record và kết quả mong đợi có thể khác.

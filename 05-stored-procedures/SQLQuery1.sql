/*========================================================
  TOPIC: MINI MART SALES MANAGEMENT
  STORED PROCEDURE: TẠO HÓA ĐƠN BÁN HÀNG
========================================================*/

-- 1. Tạo database
IF DB_ID('MiniMartDB') IS NULL
BEGIN
    CREATE DATABASE MiniMartDB;
END;
GO

USE MiniMartDB;
GO

/*========================================================
  2. XÓA CÁC BẢNG CŨ NẾU ĐÃ TỒN TẠI
========================================================*/

IF OBJECT_ID('ChiTietHoaDon', 'U') IS NOT NULL
    DROP TABLE ChiTietHoaDon;

IF OBJECT_ID('HoaDon', 'U') IS NOT NULL
    DROP TABLE HoaDon;

IF OBJECT_ID('SanPham', 'U') IS NOT NULL
    DROP TABLE SanPham;

IF OBJECT_ID('KhachHang', 'U') IS NOT NULL
    DROP TABLE KhachHang;

IF OBJECT_ID('NhanVien', 'U') IS NOT NULL
    DROP TABLE NhanVien;
GO

/*========================================================
  3. TẠO CÁC BẢNG
========================================================*/

CREATE TABLE NhanVien
(
    MaNV INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15),
    ChucVu NVARCHAR(50)
);
GO

CREATE TABLE KhachHang
(
    MaKH INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15),
    DiaChi NVARCHAR(200)
);
GO

CREATE TABLE SanPham
(
    MaSP INT IDENTITY(1,1) PRIMARY KEY,
    TenSP NVARCHAR(100) NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    SoLuongTon INT NOT NULL,

    CONSTRAINT CK_SanPham_DonGia
        CHECK (DonGia >= 0),

    CONSTRAINT CK_SanPham_SoLuongTon
        CHECK (SoLuongTon >= 0)
);
GO

CREATE TABLE HoaDon
(
    MaHD INT IDENTITY(1,1) PRIMARY KEY,
    NgayLap DATETIME NOT NULL
        CONSTRAINT DF_HoaDon_NgayLap DEFAULT GETDATE(),

    MaNV INT NOT NULL,
    MaKH INT NULL,
    TongTien DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_HoaDon_TongTien DEFAULT 0,

    CONSTRAINT FK_HoaDon_NhanVien
        FOREIGN KEY (MaNV)
        REFERENCES NhanVien(MaNV),

    CONSTRAINT FK_HoaDon_KhachHang
        FOREIGN KEY (MaKH)
        REFERENCES KhachHang(MaKH),

    CONSTRAINT CK_HoaDon_TongTien
        CHECK (TongTien >= 0)
);
GO

CREATE TABLE ChiTietHoaDon
(
    MaHD INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    ThanhTien DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_ChiTietHoaDon
        PRIMARY KEY (MaHD, MaSP),

    CONSTRAINT FK_ChiTietHoaDon_HoaDon
        FOREIGN KEY (MaHD)
        REFERENCES HoaDon(MaHD),

    CONSTRAINT FK_ChiTietHoaDon_SanPham
        FOREIGN KEY (MaSP)
        REFERENCES SanPham(MaSP),

    CONSTRAINT CK_ChiTietHoaDon_SoLuong
        CHECK (SoLuong > 0),

    CONSTRAINT CK_ChiTietHoaDon_DonGia
        CHECK (DonGia >= 0),

    CONSTRAINT CK_ChiTietHoaDon_ThanhTien
        CHECK (ThanhTien >= 0)
);
GO

/*========================================================
  4. THÊM DỮ LIỆU MẪU
========================================================*/

INSERT INTO NhanVien
(
    HoTen,
    SoDienThoai,
    ChucVu
)
VALUES
(N'Nguyễn Văn An', '0901234567', N'Nhân viên bán hàng'),
(N'Trần Thị Bình', '0912345678', N'Quản lý');
GO

INSERT INTO KhachHang
(
    HoTen,
    SoDienThoai,
    DiaChi
)
VALUES
(N'Lê Minh Khang', '0923456789', N'Cà Mau'),
(N'Phạm Ngọc Lan', '0934567890', N'Bạc Liêu');
GO

INSERT INTO SanPham
(
    TenSP,
    DonGia,
    SoLuongTon
)
VALUES
(N'Coca Cola', 10000, 50),
(N'Mì Hảo Hảo', 5000, 100),
(N'Nước suối Aquafina', 7000, 80),
(N'Bánh Oreo', 15000, 40);
GO

/*========================================================
  5. TẠO STORED PROCEDURE
========================================================*/

CREATE OR ALTER PROCEDURE sp_CreateSalesInvoice
    @MaNV INT,
    @MaKH INT = NULL,
    @MaSP INT,
    @SoLuong INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @DonGia DECIMAL(18,2);
    DECLARE @SoLuongTon INT;
    DECLARE @ThanhTien DECIMAL(18,2);
    DECLARE @MaHD INT;

    /* Kiểm tra số lượng mua */
    IF @SoLuong IS NULL OR @SoLuong <= 0
    BEGIN
        THROW 50001, N'Số lượng mua phải lớn hơn 0.', 1;
    END;

    /* Kiểm tra nhân viên */
    IF NOT EXISTS
    (
        SELECT 1
        FROM NhanVien
        WHERE MaNV = @MaNV
    )
    BEGIN
        THROW 50002, N'Mã nhân viên không tồn tại.', 1;
    END;

    /* Kiểm tra khách hàng nếu có truyền mã khách hàng */
    IF @MaKH IS NOT NULL
       AND NOT EXISTS
       (
           SELECT 1
           FROM KhachHang
           WHERE MaKH = @MaKH
       )
    BEGIN
        THROW 50003, N'Mã khách hàng không tồn tại.', 1;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        /*
            Khóa dòng sản phẩm trong quá trình bán hàng,
            tránh hai giao dịch cùng trừ tồn kho.
        */
        SELECT
            @DonGia = DonGia,
            @SoLuongTon = SoLuongTon
        FROM SanPham WITH (UPDLOCK, HOLDLOCK)
        WHERE MaSP = @MaSP;

        /* Kiểm tra sản phẩm */
        IF @DonGia IS NULL
        BEGIN
            THROW 50004, N'Sản phẩm không tồn tại.', 1;
        END;

        /* Kiểm tra tồn kho */
        IF @SoLuongTon < @SoLuong
        BEGIN
            THROW 50005, N'Số lượng sản phẩm trong kho không đủ.', 1;
        END;

        SET @ThanhTien = @DonGia * @SoLuong;

        /* Tạo hóa đơn */
        INSERT INTO HoaDon
        (
            NgayLap,
            MaNV,
            MaKH,
            TongTien
        )
        VALUES
        (
            GETDATE(),
            @MaNV,
            @MaKH,
            @ThanhTien
        );

        SET @MaHD = CONVERT(INT, SCOPE_IDENTITY());

        /* Thêm chi tiết hóa đơn */
        INSERT INTO ChiTietHoaDon
        (
            MaHD,
            MaSP,
            SoLuong,
            DonGia,
            ThanhTien
        )
        VALUES
        (
            @MaHD,
            @MaSP,
            @SoLuong,
            @DonGia,
            @ThanhTien
        );

        /* Trừ số lượng tồn kho */
        UPDATE SanPham
        SET SoLuongTon = SoLuongTon - @SoLuong
        WHERE MaSP = @MaSP;

        COMMIT TRANSACTION;

        /* Trả về kết quả hóa đơn vừa tạo */
        SELECT
            HD.MaHD,
            HD.NgayLap,
            NV.HoTen AS TenNhanVien,
            ISNULL(KH.HoTen, N'Khách lẻ') AS TenKhachHang,
            SP.MaSP,
            SP.TenSP,
            CTHD.SoLuong,
            CTHD.DonGia,
            CTHD.ThanhTien,
            HD.TongTien,
            SP.SoLuongTon AS SoLuongTonConLai,
            N'Tạo hóa đơn thành công' AS ThongBao
        FROM HoaDon AS HD
        INNER JOIN NhanVien AS NV
            ON HD.MaNV = NV.MaNV
        LEFT JOIN KhachHang AS KH
            ON HD.MaKH = KH.MaKH
        INNER JOIN ChiTietHoaDon AS CTHD
            ON HD.MaHD = CTHD.MaHD
        INNER JOIN SanPham AS SP
            ON CTHD.MaSP = SP.MaSP
        WHERE HD.MaHD = @MaHD;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

/*========================================================
  6. CHẠY THỬ STORED PROCEDURE
========================================================*/

-- Khách hàng có đăng ký
EXEC sp_CreateSalesInvoice
    @MaNV = 1,
    @MaKH = 1,
    @MaSP = 1,
    @SoLuong = 3;
GO

-- Khách lẻ: đặt MaKH = NULL
EXEC sp_CreateSalesInvoice
    @MaNV = 1,
    @MaKH = NULL,
    @MaSP = 2,
    @SoLuong = 5;
GO

/*========================================================
  7. KIỂM TRA KẾT QUẢ
========================================================*/

SELECT * FROM NhanVien;
SELECT * FROM KhachHang;
SELECT * FROM SanPham;
SELECT * FROM HoaDon;
SELECT * FROM ChiTietHoaDon;
GO
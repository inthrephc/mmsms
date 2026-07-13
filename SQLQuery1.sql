CREATE PROCEDURE sp_CreateSalesInvoice
    @MaNV INT,
    @MaKH INT = NULL,
    @MaSP INT,
    @SoLuong INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @DonGia DECIMAL(18, 2);
    DECLARE @SoLuongTon INT;
    DECLARE @ThanhTien DECIMAL(18, 2);
    DECLARE @MaHD INT;

    IF @SoLuong <= 0
    BEGIN
        RAISERROR(N'Số lượng mua phải lớn hơn 0.', 16, 1);
        RETURN;
    END;

    SELECT
        @DonGia = DonGia,
        @SoLuongTon = SoLuongTon
    FROM SanPham
    WHERE MaSP = @MaSP;

    IF @DonGia IS NULL
    BEGIN
        RAISERROR(N'Sản phẩm không tồn tại.', 16, 1);
        RETURN;
    END;

    IF @SoLuongTon < @SoLuong
    BEGIN
        RAISERROR(N'Số lượng sản phẩm trong kho không đủ.', 16, 1);
        RETURN;
    END;

    SET @ThanhTien = @DonGia * @SoLuong;

    BEGIN TRY
        BEGIN TRANSACTION;

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

        SET @MaHD = SCOPE_IDENTITY();

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

        UPDATE SanPham
        SET SoLuongTon = SoLuongTon - @SoLuong
        WHERE MaSP = @MaSP;

        COMMIT TRANSACTION;

        SELECT
            @MaHD AS MaHoaDon,
            @MaSP AS MaSanPham,
            @SoLuong AS SoLuongMua,
            @DonGia AS DonGia,
            @ThanhTien AS TongTien,
            N'Tạo hóa đơn thành công' AS ThongBao;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO  
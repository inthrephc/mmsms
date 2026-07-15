-- MINI MART SALES MANAGEMENT
-- Function: Calculate invoice total

IF DB_ID('MiniMartDB') IS NULL
    CREATE DATABASE MiniMartDB;
GO

USE MiniMartDB;
GO

-- Xóa đối tượng cũ để có thể chạy lại
DROP FUNCTION IF EXISTS dbo.fn_CalculateInvoiceTotal;
DROP TABLE IF EXISTS dbo.InvoiceDetails;
DROP TABLE IF EXISTS dbo.Invoices;
GO

-- Bảng hóa đơn
CREATE TABLE dbo.Invoices
(
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceDate DATETIME DEFAULT GETDATE(),
    CustomerName NVARCHAR(100)
);
GO

-- Bảng chi tiết hóa đơn
CREATE TABLE dbo.InvoiceDetails
(
    InvoiceID INT,
    ProductName NVARCHAR(100),
    Quantity INT CHECK (Quantity > 0),
    UnitPrice DECIMAL(18,2) CHECK (UnitPrice >= 0),
    DiscountPercent DECIMAL(5,2) DEFAULT 0,

    CONSTRAINT FK_InvoiceDetails_Invoices
        FOREIGN KEY (InvoiceID)
        REFERENCES dbo.Invoices(InvoiceID)
);
GO

-- Dữ liệu mẫu
INSERT INTO dbo.Invoices (CustomerName)
VALUES (N'Nguyễn Văn An');

INSERT INTO dbo.InvoiceDetails
    (InvoiceID, ProductName, Quantity, UnitPrice, DiscountPercent)
VALUES
    (1, N'Nước suối', 2, 10000, 0),
    (1, N'Bánh snack', 1, 20000, 10),
    (1, N'Sô cô la', 2, 25000, 5);
GO

-- Function tính tổng tiền hóa đơn
CREATE FUNCTION dbo.fn_CalculateInvoiceTotal
(
    @InvoiceID INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Total DECIMAL(18,2);

    SELECT @Total = ISNULL
    (
        SUM(Quantity * UnitPrice *
            (1 - DiscountPercent / 100.0)),
        0
    )
    FROM dbo.InvoiceDetails
    WHERE InvoiceID = @InvoiceID;

    RETURN @Total;
END;
GO

-- Kiểm tra kết quả
SELECT dbo.fn_CalculateInvoiceTotal(1) AS TotalAmount;
GO

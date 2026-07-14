-- This script create the database, tables, and sample data

-- To create an empty database without sample data, follow up the script 
--     until the end of the table creation section and ignore the sample data insertion section.

USE master;
GO

IF DB_ID(N'MiniMartSalesManagement') IS NOT NULL
BEGIN
    ALTER DATABASE MiniMartSalesManagement
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE MiniMartSalesManagement;
END;
GO

CREATE DATABASE MiniMartSalesManagement;
GO

USE MiniMartSalesManagement;
GO

CREATE TABLE dbo.CATEGORY
(
    category_id INT IDENTITY(1,1) NOT NULL,
    category_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255) NULL,

    CONSTRAINT PK_CATEGORY PRIMARY KEY (category_id)
);
GO

CREATE TABLE dbo.[PRODUCT]
(
    product_id INT IDENTITY(1,1) NOT NULL,
    product_name NVARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,

    CONSTRAINT PK_PRODUCT PRIMARY KEY (product_id),
    CONSTRAINT FK_PRODUCT_CATEGORY
        FOREIGN KEY (category_id)
        REFERENCES dbo.CATEGORY (category_id),
    CONSTRAINT CK_PRODUCT_UNIT_PRICE
        CHECK (unit_price >= 0),
    CONSTRAINT CK_PRODUCT_STOCK_QUANTITY
        CHECK (stock_quantity >= 0)
);
GO

CREATE TABLE dbo.CUSTOMER
(
    customer_id INT IDENTITY(1,1) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    address NVARCHAR(255) NULL,

    CONSTRAINT PK_CUSTOMER PRIMARY KEY (customer_id)
);
GO

CREATE TABLE dbo.EMPLOYEE
(
    employee_id INT IDENTITY(1,1) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    position NVARCHAR(50) NOT NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    hire_date DATE NOT NULL,

    CONSTRAINT PK_EMPLOYEE PRIMARY KEY (employee_id)
);
GO

CREATE TABLE dbo.INVOICE
(
    invoice_id INT IDENTITY(1,1) NOT NULL,
    customer_id INT NULL,
    employee_id INT NOT NULL,
    invoice_datetime DATETIME2 NOT NULL,
    payment_method INT NOT NULL,

    CONSTRAINT PK_INVOICE PRIMARY KEY (invoice_id),
    CONSTRAINT FK_INVOICE_CUSTOMER
        FOREIGN KEY (customer_id)
        REFERENCES dbo.CUSTOMER (customer_id),
    CONSTRAINT FK_INVOICE_EMPLOYEE
        FOREIGN KEY (employee_id)
        REFERENCES dbo.EMPLOYEE (employee_id),
    CONSTRAINT CK_INVOICE_PAYMENT_METHOD
        CHECK (payment_method IN (1, 2, 3))
);
GO

CREATE TABLE dbo.INVOICE_DETAIL
(
    invoice_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_INVOICE_DETAIL
        PRIMARY KEY (invoice_id, product_id),
    CONSTRAINT FK_INVOICE_DETAIL_INVOICE
        FOREIGN KEY (invoice_id)
        REFERENCES dbo.INVOICE (invoice_id),
    CONSTRAINT FK_INVOICE_DETAIL_PRODUCT
        FOREIGN KEY (product_id)
        REFERENCES dbo.[PRODUCT] (product_id),
    CONSTRAINT CK_INVOICE_DETAIL_QUANTITY
        CHECK (quantity > 0),
    CONSTRAINT CK_INVOICE_DETAIL_UNIT_PRICE
        CHECK (unit_price >= 0)
);
GO

CREATE INDEX IX_PRODUCT_CATEGORY_ID
ON dbo.[PRODUCT] (category_id);
GO

CREATE INDEX IX_INVOICE_CUSTOMER_ID
ON dbo.INVOICE (customer_id);
GO

CREATE INDEX IX_INVOICE_EMPLOYEE_ID
ON dbo.INVOICE (employee_id);
GO

CREATE INDEX IX_INVOICE_DETAIL_PRODUCT_ID
ON dbo.INVOICE_DETAIL (product_id);
GO

-- IGNORE THE FOLLOWING SECTION IF YOU WANT TO CREATE AN EMPTY DATABASE WITHOUT SAMPLE DATA

INSERT INTO dbo.CATEGORY (category_name, description)
VALUES
    (N'Food', N'Packaged food and snacks'),
    (N'Drinks', N'Bottled and canned beverages'),
    (N'Household Items', N'Basic household supplies'),
    (N'Personal Care', N'Personal hygiene and care products');
GO

-- The stock quantities below represent current stock at the time the sample database is created.
-- The historical sample invoices inserted later do not deduct these quantities again.
INSERT INTO dbo.[PRODUCT] (product_name, category_id, unit_price, stock_quantity)
VALUES
    (N'Instant Noodles', 1, 4500.00, 120),
    (N'Chocolate Biscuit', 1, 12000.00, 80),
    (N'Milk Bread', 1, 18000.00, 35),
    (N'Bottled Water 500ml', 2, 6000.00, 200),
    (N'Orange Juice 1L', 2, 32000.00, 45),
    (N'Dishwashing Liquid', 3, 28000.00, 50),
    (N'Tissue Box', 3, 22000.00, 70),
    (N'Toothpaste', 4, 35000.00, 60);
GO

INSERT INTO dbo.CUSTOMER (full_name, phone, email, address)
VALUES
    (N'Nguyen Minh Anh', '0901000001', 'minhanh@example.com', N'District 1, Ho Chi Minh City'),
    (N'Tran Bao Long', '0901000002', 'baolong@example.com', N'District 3, Ho Chi Minh City'),
    (N'Le Thu Ha', '0901000003', 'thuha@example.com', N'Binh Thanh District, Ho Chi Minh City');
GO

INSERT INTO dbo.EMPLOYEE (full_name, position, phone, email, hire_date)
VALUES
    (N'Pham Quoc Huy', N'Cashier', '0912000001', 'huy.pham@example.com', '2024-03-15'),
    (N'Vo Ngoc Mai', N'Sales Staff', '0912000002', 'mai.vo@example.com', '2024-06-01'),
    (N'Dang Thanh Son', N'Manager', '0912000003', 'son.dang@example.com', '2023-11-20');
GO

INSERT INTO dbo.INVOICE (customer_id, employee_id, invoice_datetime, payment_method)
VALUES
    (1, 1, '2026-07-01T08:30:00', 1),
    (NULL, 2, '2026-07-01T10:15:00', 3),
    (2, 1, '2026-07-02T14:05:00', 2),
    (3, 2, '2026-07-03T18:40:00', 1),
    (NULL, 1, '2026-07-04T09:20:00', 1);
GO

-- These are historical demonstration details. Inventory updates for new sales are handled
-- by the inventory trigger after the trigger is installed.
INSERT INTO dbo.INVOICE_DETAIL (invoice_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 5, 4500.00),
    (1, 4, 2, 6000.00),
    (1, 8, 1, 35000.00),
    (2, 2, 3, 12000.00),
    (2, 5, 1, 32000.00),
    (3, 6, 2, 28000.00),
    (3, 7, 4, 22000.00),
    (4, 3, 2, 18000.00),
    (4, 4, 6, 6000.00),
    (5, 1, 10, 4500.00),
    (5, 2, 2, 12000.00);
GO

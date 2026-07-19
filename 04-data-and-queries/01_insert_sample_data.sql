USE MiniMartSalesManagement;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @inventory_trigger_id INT =
    OBJECT_ID(N'dbo.trg_AdjustStock_AfterInvoiceDetailChange', N'TR');
DECLARE @inventory_trigger_was_disabled BIT =
    CASE
        WHEN @inventory_trigger_id IS NOT NULL
             AND OBJECTPROPERTY(@inventory_trigger_id, N'ExecIsTriggerDisabled') = 1
        THEN 1
        ELSE 0
    END;

BEGIN TRY
    BEGIN TRANSACTION;

    -- These invoice details represent historical sales. Temporarily disable the
    -- inventory trigger, if installed, so the inserted stock remains current stock.
    IF @inventory_trigger_id IS NOT NULL
       AND @inventory_trigger_was_disabled = 0
    BEGIN
        DISABLE TRIGGER dbo.trg_AdjustStock_AfterInvoiceDetailChange
        ON dbo.INVOICE_DETAIL;
    END;

    -- Replace the default seed data with a deterministic Step 4 dataset.
    DELETE FROM dbo.INVOICE_DETAIL;
    DELETE FROM dbo.INVOICE;
    DELETE FROM dbo.[PRODUCT];
    DELETE FROM dbo.CATEGORY;
    DELETE FROM dbo.CUSTOMER;
    DELETE FROM dbo.EMPLOYEE;

    DBCC CHECKIDENT (N'dbo.INVOICE', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT (N'dbo.PRODUCT', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT (N'dbo.CATEGORY', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT (N'dbo.CUSTOMER', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT (N'dbo.EMPLOYEE', RESEED, 0) WITH NO_INFOMSGS;

    INSERT INTO dbo.CATEGORY (category_name, description)
    VALUES
        (N'Food', N'Packaged food, bread, and snacks'),
        (N'Drinks', N'Bottled drinks, juice, and coffee'),
        (N'Household Items', N'Cleaning products and household supplies'),
        (N'Personal Care', N'Personal hygiene and care products'),
        (N'Stationery', N'Basic school and office supplies'),
        (N'Seasonal', N'Seasonal products; currently has no products');

    -- Stock cases include high, low, exactly 50, and zero stock.
    INSERT INTO dbo.[PRODUCT]
        (product_name, category_id, unit_price, stock_quantity)
    VALUES
        (N'Instant Noodles',          1,   4500.00, 120),
        (N'Chocolate Biscuit',        1,  12000.00,   8),
        (N'Milk Bread',               1,  18000.00,   0),
        (N'Bottled Water 500ml',      2,   6000.00, 200),
        (N'Orange Juice 1L',          2,  32000.00,  45),
        (N'Ground Coffee 500g',       2,  85000.00,  25),
        (N'Dishwashing Liquid',       3,  28000.00,  50),
        (N'Tissue Box',               3,  22000.00,  70),
        (N'Laundry Detergent 3kg',    3, 115000.00,  18),
        (N'Toothpaste',               4,  35000.00,  60),
        (N'Shampoo 650ml',            4,  92000.00,  35),
        (N'Hand Sanitizer',           4,  30000.00,   0),
        (N'Notebook A5',              5,  15000.00,  90),
        (N'Ballpoint Pen',            5,   5000.00, 150);

    -- Nullable contact fields demonstrate optional customer information.
    INSERT INTO dbo.CUSTOMER (full_name, phone, email, address)
    VALUES
        (N'Nguyen Minh Anh', '0901000001', 'minhanh@example.com', N'District 1, Ho Chi Minh City'),
        (N'Tran Bao Long',   '0901000002', 'baolong@example.com', NULL),
        (N'Le Thu Ha',       '0901000003', NULL, N'Binh Thanh District, Ho Chi Minh City'),
        (N'Pham Gia Bao',    NULL, 'giabao@example.com', N'Go Vap District, Ho Chi Minh City'),
        (N'Hoang Lan Chi',   '0901000005', 'lanchi@example.com', N'District 7, Ho Chi Minh City'),
        (N'Vo Tuan Kiet',    '0901000006', NULL, NULL);

    -- Employee 4 intentionally has no invoice.
    INSERT INTO dbo.EMPLOYEE
        (full_name, position, phone, email, hire_date)
    VALUES
        (N'Pham Quoc Huy', N'Cashier',     '0912000001', 'huy.pham@example.com', '2024-03-15'),
        (N'Vo Ngoc Mai',   N'Sales Staff', '0912000002', 'mai.vo@example.com',   '2024-06-01'),
        (N'Dang Thanh Son',N'Manager',     '0912000003', 'son.dang@example.com', '2023-11-20'),
        (N'Bui Thanh An',  N'Cashier',     NULL,          'an.bui@example.com',   '2026-06-10');

    -- Includes registered and walk-in customers, every payment method, multiple
    -- employees, multiple invoices per day, and customers with no invoice.
    INSERT INTO dbo.INVOICE
        (customer_id, employee_id, invoice_datetime, payment_method)
    VALUES
        (1,    1, '2026-07-01T08:30:00', 1),
        (NULL, 2, '2026-07-01T10:15:00', 3),
        (2,    1, '2026-07-02T14:05:00', 2),
        (3,    2, '2026-07-03T18:40:00', 1),
        (NULL, 1, '2026-07-04T09:20:00', 1),
        (1,    3, '2026-07-04T19:00:00', 2),
        (4,    2, '2026-07-05T11:10:00', 3),
        (5,    1, '2026-07-05T16:25:00', 1),
        (NULL, 3, '2026-07-06T08:45:00', 3),
        (2,    2, '2026-07-06T20:15:00', 2),
        (4,    1, '2026-07-07T12:00:00', 1),
        (1,    2, '2026-07-07T17:30:00', 3);

    -- Historical unit prices intentionally differ from current prices for several
    -- products to demonstrate price history in INVOICE_DETAIL.
    INSERT INTO dbo.INVOICE_DETAIL
        (invoice_id, product_id, quantity, unit_price)
    VALUES
        (1,  1,  5,   4500.00),
        (1,  4,  2,   6000.00),
        (1, 10,  1,  33000.00),
        (2,  2,  3,  12000.00),
        (2,  5,  1,  32000.00),
        (3,  7,  2,  28000.00),
        (3,  8,  4,  22000.00),
        (4,  3,  2,  18000.00),
        (4,  4,  6,   6000.00),
        (5,  1, 10,   4500.00),
        (5,  2,  2,  12000.00),
        (5, 14,  5,   5000.00),
        (6,  6,  1,  79000.00),
        (6,  2,  2,  12000.00),
        (7,  9,  1, 115000.00),
        (7,  7,  1,  28000.00),
        (8, 10,  2,  35000.00),
        (8, 11,  1,  90000.00),
        (9,  4, 12,   6000.00),
        (9,  1,  6,   4500.00),
        (9, 14, 10,   5000.00),
        (10, 6,  2,  85000.00),
        (10, 5,  2,  32000.00),
        (11, 8,  3,  22000.00),
        (11, 7,  2,  28000.00),
        (11,10,  1,  35000.00),
        (12, 1,  4,   4500.00),
        (12, 4,  4,   6000.00),
        (12, 2,  1,  12000.00);

    IF @inventory_trigger_id IS NOT NULL
       AND @inventory_trigger_was_disabled = 0
    BEGIN
        ENABLE TRIGGER dbo.trg_AdjustStock_AfterInvoiceDetailChange
        ON dbo.INVOICE_DETAIL;
    END;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    -- Restore the trigger if an unexpected error left it disabled.
    IF @inventory_trigger_id IS NOT NULL
       AND @inventory_trigger_was_disabled = 0
       AND OBJECTPROPERTY(@inventory_trigger_id, N'ExecIsTriggerDisabled') = 1
    BEGIN
        ENABLE TRIGGER dbo.trg_AdjustStock_AfterInvoiceDetailChange
        ON dbo.INVOICE_DETAIL;
    END;

    THROW;
END CATCH;
GO

SELECT N'CATEGORY' AS table_name, COUNT(*) AS row_count FROM dbo.CATEGORY
UNION ALL
SELECT N'PRODUCT', COUNT(*) FROM dbo.[PRODUCT]
UNION ALL
SELECT N'CUSTOMER', COUNT(*) FROM dbo.CUSTOMER
UNION ALL
SELECT N'EMPLOYEE', COUNT(*) FROM dbo.EMPLOYEE
UNION ALL
SELECT N'INVOICE', COUNT(*) FROM dbo.INVOICE
UNION ALL
SELECT N'INVOICE_DETAIL', COUNT(*) FROM dbo.INVOICE_DETAIL;
GO

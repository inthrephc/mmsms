INSERT INTO dbo.CATEGORY (category_name, description)
VALUES
    (N'Food', N'Packaged food and snacks'),
    (N'Drinks', N'Bottled and canned beverages'),
    (N'Household Items', N'Basic household supplies'),
    (N'Personal Care', N'Personal hygiene and care products');

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

INSERT INTO dbo.CUSTOMER (full_name, phone, email, address)
VALUES
    (N'Nguyen Minh Anh', '0901000001', 'minhanh@example.com', N'District 1, Ho Chi Minh City'),
    (N'Tran Bao Long', '0901000002', 'baolong@example.com', N'District 3, Ho Chi Minh City'),
    (N'Le Thu Ha', '0901000003', 'thuha@example.com', N'Binh Thanh District, Ho Chi Minh City');

INSERT INTO dbo.EMPLOYEE (full_name, position, phone, email, hire_date)
VALUES
    (N'Pham Quoc Huy', N'Cashier', '0912000001', 'huy.pham@example.com', '2024-03-15'),
    (N'Vo Ngoc Mai', N'Sales Staff', '0912000002', 'mai.vo@example.com', '2024-06-01'),
    (N'Dang Thanh Son', N'Manager', '0912000003', 'son.dang@example.com', '2023-11-20');

INSERT INTO dbo.INVOICE (customer_id, employee_id, invoice_datetime, payment_method)
VALUES
    (1, 1, '2026-07-01T08:30:00', 1),
    (NULL, 2, '2026-07-01T10:15:00', 3),
    (2, 1, '2026-07-02T14:05:00', 2),
    (3, 2, '2026-07-03T18:40:00', 1),
    (NULL, 1, '2026-07-04T09:20:00', 1);

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

INSERT INTO dbo.CATEGORY (category_name, description)
VALUES
        (N'Food', N'Packaged food, bread, and snacks'),
        (N'Drinks', N'Bottled drinks, juice, and coffee'),
        (N'Household Items', N'Cleaning products and household supplies'),
        (N'Personal Care', N'Personal hygiene and care products'),
        (N'Stationery', N'Basic school and office supplies'),
        (N'Seasonal', N'Seasonal products; currently has no products');

INSERT INTO dbo.[PRODUCT] (product_name, category_id, unit_price, stock_quantity)
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

INSERT INTO dbo.CUSTOMER (full_name, phone, email, address)
VALUES
        (N'Nguyen Minh Anh', '0901000001', 'minhanh@example.com', N'District 1, Ho Chi Minh City'),
        (N'Tran Bao Long',   '0901000002', 'baolong@example.com', NULL),
        (N'Le Thu Ha',       '0901000003', NULL,                  N'Binh Thanh District, Ho Chi Minh City'),
        (N'Pham Gia Bao',    NULL,         'giabao@example.com',  N'Go Vap District, Ho Chi Minh City'),
        (N'Hoang Lan Chi',   '0901000005', 'lanchi@example.com',  N'District 7, Ho Chi Minh City'),
        (N'Vo Tuan Kiet',    '0901000006', NULL,                  NULL);

INSERT INTO dbo.EMPLOYEE (full_name, position, phone, email, hire_date)
VALUES
        (N'Pham Quoc Huy',   N'Cashier',     '0912000001', 'huy.pham@example.com', '2024-03-15'),
        (N'Vo Ngoc Mai',     N'Sales Staff', '0912000002', 'mai.vo@example.com',   '2024-06-01'),
        (N'Dang Thanh Son',  N'Manager',     '0912000003', 'son.dang@example.com', '2023-11-20'),
        (N'Bui Thanh An',    N'Cashier',     NULL,         'an.bui@example.com',   '2026-06-10');

INSERT INTO dbo.INVOICE (customer_id, employee_id, invoice_datetime, payment_method)
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

INSERT INTO dbo.INVOICE_DETAIL (invoice_id, product_id, quantity, unit_price)
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

CREATE TABLE dbo.CATEGORY
(
    category_id INT IDENTITY(1,1) NOT NULL,
    category_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255) NULL,

    CONSTRAINT PK_CATEGORY PRIMARY KEY (category_id)
);

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

CREATE TABLE dbo.CUSTOMER
(
    customer_id INT IDENTITY(1,1) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    address NVARCHAR(255) NULL,

    CONSTRAINT PK_CUSTOMER PRIMARY KEY (customer_id)
);

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

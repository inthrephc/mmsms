# Relational Database Model

## Purpose

This folder converts the Chen ERD into a relational database model. Each strong entity becomes a table, and relationships are implemented with primary keys, foreign keys, and one associative table.

The diagram for this model is stored in [`uml.mmd`](uml.mmd).

## 1. Relational Schema Overview

| Table | Primary Key | Foreign Keys | Notes |
| ----- | ----------- | ------------ | ----- |
| `CATEGORY` | `category_id` | None | Stores product category information. |
| `PRODUCT` | `product_id` | `category_id` | Each product belongs to one category. |
| `CUSTOMER` | `customer_id` | None | Stores registered customer information. |
| `EMPLOYEE` | `employee_id` | None | Stores employee information. |
| `INVOICE` | `invoice_id` | `customer_id`, `employee_id` | Stores completed sales invoices. |
| `INVOICE_DETAIL` | `(invoice_id, product_id)` | `invoice_id`, `product_id` | Associative table created from the N-N relationship between `INVOICE` and `PRODUCT`. |

## 3. Table Description

### Table: `CATEGORY`

| Column Name     | Data Type     | PK | FK | Not Null | Description                         |
| --------------- | ------------- | -- | -- | -------- | ----------------------------------- |
| `category_id`   | INT           | ✓  |    | ✓        | Unique identifier of each category. |
| `category_name` | NVARCHAR(100) |    |    | ✓        | Name of the product category.       |
| `description`   | NVARCHAR(255) |    |    |          | Short description of the category.  |

### Table: `PRODUCT`

| Column Name      | Data Type     | PK | FK | Not Null | Description                               |
| ---------------- | ------------- | -- | -- | -------- | ----------------------------------------- |
| `product_id`     | INT           | ✓  |    | ✓        | Unique identifier of each product.        |
| `product_name`   | NVARCHAR(150) |    |    | ✓        | Name of the product.                      |
| `category_id`    | INT           |    | ✓  | ✓        | References `CATEGORY(category_id)`.       |
| `unit_price`     | DECIMAL(10,2) |    |    | ✓        | Current selling price of the product.     |
| `stock_quantity` | INT           |    |    | ✓        | Current quantity of the product in stock. |

### Table: `CUSTOMER`

| Column Name   | Data Type     | PK | FK | Not Null | Description                                    |
| ------------- | ------------- | -- | -- | -------- | ---------------------------------------------- |
| `customer_id` | INT           | ✓  |    | ✓        | Unique identifier of each registered customer. |
| `full_name`   | NVARCHAR(100) |    |    | ✓        | Full name of the customer.                     |
| `phone`       | VARCHAR(20)   |    |    |          | Customer phone number.                         |
| `email`       | VARCHAR(100)  |    |    |          | Customer email address.                        |
| `address`     | NVARCHAR(255) |    |    |          | Customer address.                              |

### Table: `EMPLOYEE`

| Column Name   | Data Type     | PK | FK | Not Null | Description                             |
| ------------- | ------------- | -- | -- | -------- | --------------------------------------- |
| `employee_id` | INT           | ✓  |    | ✓        | Unique identifier of each employee.     |
| `full_name`   | NVARCHAR(100) |    |    | ✓        | Full name of the employee.              |
| `position`    | NVARCHAR(50)  |    |    | ✓        | Job position of the employee.           |
| `phone`       | VARCHAR(20)   |    |    |          | Employee phone number.                  |
| `email`       | VARCHAR(100)  |    |    |          | Employee email address.                 |
| `hire_date`   | DATE          |    |    | ✓        | Date when the employee started working. |

### Table: `INVOICE`

| Column Name        | Data Type | PK | FK | Not Null | Description                                                         |
| ------------------ | --------- | -- | -- | -------- | ------------------------------------------------------------------- |
| `invoice_id`       | INT       | ✓  |    | ✓        | Unique identifier of each invoice.                                  |
| `customer_id`      | INT       |    | ✓  |          | References `CUSTOMER(customer_id)`. Nullable for walk-in customers. |
| `employee_id`      | INT       |    | ✓  | ✓        | References `EMPLOYEE(employee_id)`.                                 |
| `invoice_datetime` | DATETIME2 |    |    | ✓        | Date and time when the invoice is created.                          |
| `payment_method`   | INT       |    |    | ✓        | Payment method used for the invoice.                                |

#### Payment method codes

| Code | Meaning       |
| ---: | ------------- |
|    1 | Cash          |
|    2 | Bank transfer |
|    3 | E-wallet      |

### Table: `INVOICE_DETAIL`

Trong Chen ERD, bảng này được tạo ra từ relationship `CONTAINS` giữa `INVOICE` và `PRODUCT`.

| Column Name  | Data Type     | PK | FK | Not Null | Description                                       |
| ------------ | ------------- | -- | -- | -------- | ------------------------------------------------- |
| `invoice_id` | INT           | ✓  | ✓  | ✓        | References `INVOICE(invoice_id)`.                 |
| `product_id` | INT           | ✓  | ✓  | ✓        | References `PRODUCT(product_id)`.                 |
| `quantity`   | INT           |    |    | ✓        | Quantity of the product sold in the invoice.      |
| `unit_price` | DECIMAL(10,2) |    |    | ✓        | Selling price of the product at the time of sale. |

**Primary key:** `(invoice_id, product_id)`

## 4. Important Design Notes

| Design Point | Explanation |
| ------------ | ----------- |
| Optional customer | `INVOICE.customer_id` can be NULL to support walk-in customers. |
| Associative table | The N-N relationship between `INVOICE` and `PRODUCT` is converted into `INVOICE_DETAIL`. |
| Composite primary key | `INVOICE_DETAIL` uses `(invoice_id, product_id)` because one product should appear only once in the same invoice. |
| Price history | `INVOICE_DETAIL.unit_price` stores the selling price at the time of sale, even if `PRODUCT.unit_price` changes later. |
| No `line_total` | It can be calculated as `quantity * unit_price`. |
| No `total_amount` | It can be calculated by summing all invoice details for one invoice. |
| `invoice_datetime` | This attribute stores both date and time, which is useful for mini mart sales. |

# 2. Entity Relationship Diagram — Chen Notation

## 1. Entity Description

| No. | Entity     | Description                                                      |
| --: | ---------- | ---------------------------------------------------------------- |
|   1 | `CATEGORY` | Stores product category information.                             |
|   2 | `PRODUCT`  | Stores product information, price, stock quantity, and category. |
|   3 | `CUSTOMER` | Stores registered customer information.                          |
|   4 | `EMPLOYEE` | Stores employee information and identifies who creates invoices. |
|   5 | `INVOICE`  | Stores completed sales invoice information.                      |

## 2. Relationship Description

| No. | Relationship | Entities               | Type   | Description                                                                                                                                                                                                |
| --: | ------------ | ---------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   1 | `BELONGS_TO` | `CATEGORY` — `PRODUCT` | 1-N    | One category can have many products. Each product belongs to exactly one category.                                                                                                                         |
|   2 | `MAKES`      | `CUSTOMER` — `INVOICE` | 0..1-N | One invoice may belong to zero or one registered customer. If there is no customer, it is a walk-in customer.                                                                                              |
|   3 | `CREATES`    | `EMPLOYEE` — `INVOICE` | 1-N    | Each invoice is created by exactly one employee. One employee can create many invoices.                                                                                                                    |
|   4 | `CONTAINS`   | `INVOICE` — `PRODUCT`  | N-N    | One invoice contains one or more products. One product can appear in many invoices. This relationship has `quantity` and `unit_price`, and will become the `INVOICE_DETAIL` table in the relational model. |

## 3. Table Description

Phần này vẫn cần có trong docs vì template báo cáo yêu cầu mô tả database/table ở dạng bảng. 

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

| Design Point                                                 | Explanation                                                                                          |
| ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------- |
| `INVOICE_DETAIL` is not drawn as a normal entity in Chen ERD | It is represented by the relationship `CONTAINS` between `INVOICE` and `PRODUCT`.                    |
| `quantity` and `unit_price` belong to `CONTAINS`             | These are relationship attributes because they describe how a product appears in a specific invoice. |
| `INVOICE_DETAIL` appears in the relational model             | When converting Chen ERD to tables, the N-N relationship `CONTAINS` becomes `INVOICE_DETAIL`.        |
| No `line_total`                                              | It can be calculated as `quantity * unit_price`.                                                     |
| No `total_amount`                                            | It can be calculated by summing invoice details.                                                     |
| Optional customer                                            | `customer_id` can be NULL to support walk-in customers.                                              |
| `invoice_datetime`                                           | Used instead of `invoice_date` because mini mart sales need both date and time.                      |

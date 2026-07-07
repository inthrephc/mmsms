# ERD Design

## 1. Entity Description

| No. | Entity | Description |
| --- | --- | --- |
| 1 | `CATEGORY` | Stores product category information. |
| 2 | `PRODUCT` | Stores product information, price, stock quantity, and category. |
| 3 | `CUSTOMER` | Stores registered customer information. |
| 4 | `EMPLOYEE` | Stores employee information and identifies who creates invoices. |
| 5 | `INVOICE` | Stores completed sales invoice information. |
| 6 | `INVOICE_DETAIL` | Stores products sold in each invoice, including quantity and selling price. |

---

## 2. Relationship Description

| No. | Relationship | Type | Description |
| --- | --- | --- | --- |
| 1 | `CATEGORY` — `PRODUCT` | 1-N | One category can contain many products. Each product belongs to one category. |
| 2 | `CUSTOMER` — `INVOICE` | 0..1-N | One invoice may belong to zero or one registered customer. If `customer_id` is NULL, it is a walk-in customer. |
| 3 | `EMPLOYEE` — `INVOICE` | 1-N | One employee can create many invoices. Each invoice is created by one employee. |
| 4 | `INVOICE` — `INVOICE_DETAIL` | 1-N | One invoice must contain one or more invoice details. Each invoice detail belongs to one invoice. |
| 5 | `PRODUCT` — `INVOICE_DETAIL` | 1-N | One product can appear in many invoice details. Each invoice detail refers to one product. |
| 6 | `INVOICE` — `PRODUCT` | N-N | One invoice can contain many products, and one product can appear in many invoices. This relationship is resolved by `INVOICE_DETAIL`. |

---

## 3. Table Description

### Table: `CATEGORY`

| Column Name | Data Type | Key | Null | Description |
| --- | --- | --- | --- | --- |
| `category_id` | INT | PK | No | Unique identifier of each category. |
| `category_name` | NVARCHAR(100) |  | No | Name of the product category. |
| `description` | NVARCHAR(255) |  | Yes | Short description of the category. |

---

### Table: `PRODUCT`

| Column Name | Data Type | Key | Null | Description |
| --- | --- | --- | --- | --- |
| `product_id` | INT | PK | No | Unique identifier of each product. |
| `product_name` | NVARCHAR(150) |  | No | Name of the product. |
| `category_id` | INT | FK | No | References `CATEGORY(category_id)`. |
| `unit_price` | DECIMAL(10,2) |  | No | Current selling price of the product. |
| `stock_quantity` | INT |  | No | Current quantity of the product in stock. |

**Notes:**

- `unit_price` should be greater than or equal to 0.
- `stock_quantity` should be greater than or equal to 0.

---

### Table: `CUSTOMER`

| Column Name | Data Type | Key | Null | Description |
| --- | --- | --- | --- | --- |
| `customer_id` | INT | PK | No | Unique identifier of each registered customer. |
| `full_name` | NVARCHAR(100) |  | No | Full name of the customer. |
| `phone` | VARCHAR(20) |  | Yes | Customer phone number. |
| `email` | VARCHAR(100) |  | Yes | Customer email address. |
| `address` | NVARCHAR(255) |  | Yes | Customer address. |

**Notes:**

- This table only stores registered customers.
- Walk-in customers do not need to be stored in this table.

---

### Table: `EMPLOYEE`

| Column Name | Data Type | Key | Null | Description |
| --- | --- | --- | --- | --- |
| `employee_id` | INT | PK | No | Unique identifier of each employee. |
| `full_name` | NVARCHAR(100) |  | No | Full name of the employee. |
| `position` | NVARCHAR(50) |  | No | Job position of the employee. |
| `phone` | VARCHAR(20) |  | Yes | Employee phone number. |
| `email` | VARCHAR(100) |  | Yes | Employee email address. |
| `hire_date` | DATE |  | No | Date when the employee started working. |

---

### Table: `INVOICE`

| Column Name | Data Type | Key | Null | Description |
| --- | --- | --- | --- | --- |
| `invoice_id` | INT | PK | No | Unique identifier of each invoice. |
| `customer_id` | INT | FK | Yes | References `CUSTOMER(customer_id)`. Nullable for walk-in customers. |
| `employee_id` | INT | FK | No | References `EMPLOYEE(employee_id)`. |
| `invoice_datetime` | DATETIME2 |  | No | Date and time when the invoice is created. |
| `payment_method` | INT |  | No | Payment method used for the invoice. |

**Payment method codes:**

| Code | Meaning |
| --- | --- |
| 1 | Cash |
| 2 | Bank transfer |
| 3 | E-wallet |

**Notes:**

- `customer_id` is nullable because the system supports walk-in customers.
- The system only stores completed sales invoices.
- `invoice_total` is not stored because it can be calculated from `INVOICE_DETAIL`.

---

### Table: `INVOICE_DETAIL`

| Column Name | Data Type | Key | Null | Description |
| --- | --- | --- | --- | --- |
| `invoice_id` | INT | PK, FK | No | References `INVOICE(invoice_id)`. |
| `product_id` | INT | PK, FK | No | References `PRODUCT(product_id)`. |
| `quantity` | INT |  | No | Quantity of the product sold in the invoice. |
| `unit_price` | DECIMAL(10,2) |  | No | Selling price of the product at the time of sale. |

**Notes:**

- Primary key: `(invoice_id, product_id)`.
- This prevents the same product from appearing twice in the same invoice.
- `unit_price` is stored here as a price snapshot because product prices may change later.
- `line_total` is not stored because it can be calculated as `quantity * unit_price`.
- `quantity` should be greater than 0.

---

## 4. Important Design Notes

| Design Point | Explanation |
| --- | --- |
| No `total_amount` in `INVOICE` | Invoice total is a derived value and should be calculated from invoice details. |
| No `line_total` in `INVOICE_DETAIL` | Line total can be calculated as `quantity * unit_price`. |
| Composite key in `INVOICE_DETAIL` | `(invoice_id, product_id)` ensures that each product appears only once in an invoice. |
| Optional customer in `INVOICE` | Supports walk-in customers by allowing `customer_id` to be NULL. |
| `invoice_datetime` instead of `invoice_date` | Mini mart sales need both date and time for sales tracking. |
| Simple payment design | Since the system only stores completed sales, only `payment_method` is needed. |

# Requirements of the Topic

## 1. System Overview

The **Mini Mart Sales Management System** is designed to manage basic in-store sales transactions of a small retail store. The system mainly focuses on creating sales invoices and recording invoice details when customers buy products.

Each invoice is created by an employee and may belong to a registered customer or a walk-in customer. Each invoice contains one or more products. For each sold product, the system records the quantity and selling price at the time of sale.

The system also supports simple product management and basic reports such as invoice total, revenue, best-selling products, and customer purchase history.

## 2. System Scope

The system focuses on the following functions:

| Scope | Description |
| --- | --- |
| Product management | Store product information, category, price, and stock quantity. |
| Category management | Group products into simple categories. |
| Customer management | Store registered customer information. Walk-in customers are allowed. |
| Employee management | Store employee information and track who creates each invoice. |
| Invoice management | Record completed sales invoices. |
| Invoice detail management | Record products, quantities, and selling prices in each invoice. |
| Basic inventory update | Decrease product stock when products are sold. |
| Basic sales reports | Calculate invoice total, revenue, best-selling products, and customer purchase history. |

## 3. Main Users

| User | Description |
| --- | --- |
| Employee | Creates invoices and records sold products. |
| Manager | Views basic sales and product reports. |
| Customer | Buys products from the mini mart. The customer may be registered or walk-in. |

## 4. Main Entities

| Entity | Description |
| --- | --- |
| `CATEGORY` | Stores product category information. |
| `PRODUCT` | Stores product information, price, stock quantity, and category. |
| `CUSTOMER` | Stores registered customer information. |
| `EMPLOYEE` | Stores employee information. |
| `INVOICE` | Stores sales invoice information. |
| `INVOICE_DETAIL` | Stores products sold in each invoice. |

## 5. Functional Requirements

| No. | Requirement | Description |
| --- | --- | --- |
| FR1 | Manage categories | The system stores product categories such as food, drinks, household items, and personal care. |
| FR2 | Manage products | The system stores product name, category, unit price, and stock quantity. |
| FR3 | Manage customers | The system stores registered customer information such as name, phone, email, and address. |
| FR4 | Support walk-in customers | The system allows creating an invoice without a registered customer. |
| FR5 | Manage employees | The system stores employee information such as name, position, phone, email, and hire date. |
| FR6 | Create invoices | An employee can create an invoice for a completed sale. |
| FR7 | Manage invoice details | Each invoice contains one or more products with quantity and selling price. |
| FR8 | Record payment method | Each invoice records the payment method used by the customer. |
| FR9 | Calculate invoice total | The total amount of an invoice is calculated from its invoice details. |
| FR10 | Update product stock | Product stock quantity decreases when products are sold. |
| FR11 | Generate sales reports | The system supports basic reports such as revenue by date, best-selling products, and customer purchase history. |

## 6. Business Rules

| No. | Business Rule |
| --- | --- |
| BR1 | Each product belongs to exactly one category. |
| BR2 | Each category can have zero or many products. |
| BR3 | Each invoice is created by exactly one employee. |
| BR4 | Each employee can create zero or many invoices. |
| BR5 | Each invoice may belong to zero or one registered customer. |
| BR6 | If `customer_id` is NULL, the invoice belongs to a walk-in customer. |
| BR7 | Each registered customer can have zero or many invoices. |
| BR8 | Each invoice must contain at least one invoice detail. |
| BR9 | Each invoice detail belongs to exactly one invoice. |
| BR10 | Each invoice detail refers to exactly one product. |
| BR11 | One product can appear in many invoice details. |
| BR12 | The primary key of `INVOICE_DETAIL` is the composite key `(invoice_id, product_id)`. |
| BR13 | The same product cannot appear twice in the same invoice. If the customer buys more of the same product, increase `quantity`. |
| BR14 | `INVOICE_DETAIL.unit_price` stores the selling price at the time of sale. |
| BR15 | `line_total` is not stored. It is calculated as `quantity * unit_price`. |
| BR16 | `invoice_total` is not stored. It is calculated by summing invoice details. |
| BR17 | `invoice_datetime` must store both date and time. |
| BR18 | Only completed sales invoices are stored in the system. |
| BR19 | `payment_method` must use fixed numeric codes. |
| BR20 | Product stock quantity must not be negative. |
| BR21 | When an invoice detail is inserted, the related product stock quantity decreases. |

## 7. Code Values

### `payment_method`

| Code | Meaning |
| --- | --- |
| 1 | Cash |
| 2 | Bank transfer |
| 3 | E-wallet |

## 8. SQL Implementation Notes

Một vài rule không thể hiện hết trên ERD, nên khi sang phần SQL cần xử lý bằng constraint, procedure, function hoặc trigger.

| Rule | SQL implementation |
| --- | --- |
| Invoice detail không được trùng sản phẩm trong cùng hóa đơn | Composite primary key `(invoice_id, product_id)` |
| Số lượng bán phải lớn hơn 0 | `CHECK (quantity > 0)` |
| Giá bán không được âm | `CHECK (unit_price >= 0)` |
| Tồn kho không được âm | `CHECK (stock_quantity >= 0)` |
| Payment method chỉ nhận giá trị hợp lệ | `CHECK (payment_method IN (1, 2, 3))` |
| Invoice total | Tính bằng function hoặc query, không lưu trong bảng |
| Giảm tồn kho sau khi bán | Dùng trigger sau khi insert vào `INVOICE_DETAIL` |
| Tạo invoice kèm detail | Nên dùng stored procedure để đảm bảo invoice có ít nhất một detail |
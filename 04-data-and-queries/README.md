# Step 4 — Sample Data and Demo Queries

## 1. Purpose

This folder provides a deterministic sample dataset and SQL queries that demonstrate filtering, joins, grouping, sorting, pattern matching, subqueries, invoice totals, revenue, best-selling products, and customer purchase history.

## 2. Prerequisites and Run Order

1. Run `03-relational-model/create_database.sql` to create the `MiniMartSalesManagement` database and its tables.
2. Run `01_insert_sample_data.sql`. This replaces the default seed rows with the Step 4 dataset.
3. Run query files `02` through `10` independently in any order.

> [!WARNING]
> `01_insert_sample_data.sql` deletes all existing rows from the six project tables before inserting the demonstration dataset. Use it only on the assignment database.

The seed script can also run after the inventory trigger has been installed. It temporarily disables `dbo.trg_AdjustStock_AfterInvoiceDetailChange` while historical invoice details are inserted, then restores the trigger to its previous state. Therefore, the inserted `PRODUCT.stock_quantity` values remain the intended current stock.

## 3. Sample Data

| Table | Rows | Cases represented |
| --- | ---: | --- |
| `CATEGORY` | 6 | Common mini-mart categories and one category with no products |
| `PRODUCT` | 14 | High, low, exactly 50, and zero stock; sold and unsold products |
| `CUSTOMER` | 6 | Complete and nullable contact information; one customer with no invoices |
| `EMPLOYEE` | 4 | Cashier, sales staff, manager, and one employee with no invoices |
| `INVOICE` | 12 | Registered and walk-in customers, all three payment methods, multiple dates and employees |
| `INVOICE_DETAIL` | 29 | Multi-product invoices, repeated products across invoices, and historical selling prices |

## 4. SQL Files and Expected Results

| Order | File | Purpose | Expected result with the supplied dataset |
| ---: | --- | --- | --- |
| 1 | `01_insert_sample_data.sql` | Reset and insert deterministic sample data | Counts: 6 categories, 14 products, 6 customers, 4 employees, 12 invoices, 29 details |
| 2 | `02_list_employees.sql` | Basic `SELECT` and sorting | Returns 4 employees ordered by name |
| 3 | `03_list_products_with_categories.sql` | Join products with their categories | Returns 14 products with category information |
| 4 | `04_list_low_stock_products.sql` | Filter products using a configurable stock threshold | With threshold 50, returns 8 products |
| 5 | `05_search_products_by_name.sql` | Pattern search using `LIKE` | With keyword `Milk`, returns `Milk Bread` |
| 6 | `06_list_customer_purchase_history.sql` | Customer purchase history using multiple joins | Customer 1 has 8 detail rows across invoices 1, 6, and 12 |
| 7 | `07_calculate_invoice_totals.sql` | Calculate totals without storing `invoice_total` | Returns totals for all 12 invoices and labels walk-in customers/payment methods |
| 8 | `08_calculate_daily_revenue.sql` | Group revenue and invoice count by date | Returns 7 dates; `2026-07-06` has the highest revenue of `383000.00` |
| 9 | `09_list_top_selling_products.sql` | Rank products by total quantity sold | Top product is `Instant Noodles` with 25 units sold |
| 10 | `10_list_unsold_products.sql` | Demonstrate a correlated `NOT EXISTS` subquery | Returns `Hand Sanitizer` and `Notebook A5` |

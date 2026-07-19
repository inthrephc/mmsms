# Step 4 — Sample Data and Demo Queries

## 1. Purpose

This folder provides a deterministic sample dataset and SQL queries that demonstrate filtering, joins, grouping, sorting, pattern matching, subqueries, invoice totals, revenue, best-selling products, and customer purchase history.

## 2. Prerequisites and Run Order

1. Run `03-relational-model/create_database.sql` to create the `MiniMartSalesManagement` database and its tables.
2. Run `01_insert_sample_data.sql`. This replaces the default seed rows with the Step 4 dataset.
3. Run query files `02` through `12` independently in any order.

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

Important demonstration cases:

- Customer 6 and employee 4 have no invoices, demonstrating zero-to-many participation.
- Invoices 2, 5, and 9 are walk-in sales with `customer_id = NULL`.
- All payment codes are present: cash (`1`), bank transfer (`2`), and e-wallet (`3`).
- The `Seasonal` category has no products.
- `Milk Bread` and `Hand Sanitizer` have zero stock; `Dishwashing Liquid` has exactly 50 units.
- `Hand Sanitizer` and `Notebook A5` have never been sold.
- Several historical prices differ from current product prices, including `Ground Coffee 500g`, `Toothpaste`, and `Shampoo 650ml`.

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
| 8 | `08_find_largest_invoice.sql` | Find the largest invoice using a CTE and aggregation | Invoice 10 is largest with a total of `234000.00` |
| 9 | `09_calculate_daily_revenue.sql` | Group revenue and invoice count by date | Returns 7 dates; `2026-07-06` has the highest revenue of `383000.00` |
| 10 | `10_list_top_selling_products.sql` | Rank products by total quantity sold | Top product is `Instant Noodles` with 25 units sold |
| 11 | `11_list_products_above_average_price.sql` | Demonstrate a scalar subquery | Returns `Laundry Detergent 3kg`, `Shampoo 650ml`, and `Ground Coffee 500g` |
| 12 | `12_list_unsold_products.sql` | Demonstrate a correlated `NOT EXISTS` subquery | Returns `Hand Sanitizer` and `Notebook A5` |

## 5. Query Coverage

| SQL concept | Demonstrated in |
| --- | --- |
| Basic selection and sorting | `02`, `03` |
| Filtering and variables | `04`, `06` |
| Pattern matching with `LIKE` | `05` |
| Inner and left joins | `03`, `06`, `07`, `08`, `10`, `12` |
| Aggregation and `GROUP BY` | `07`, `08`, `09`, `10` |
| CTE | `08` |
| Scalar subquery | `11` |
| Correlated subquery with `NOT EXISTS` | `12` |
| Calculated line and invoice totals | `06`, `07`, `08`, `09`, `10` |

## 6. Notes

- Invoice totals and line totals are calculated from `quantity * unit_price`; they are not stored in the schema.
- Reports use `INVOICE_DETAIL.unit_price`, not the current `PRODUCT.unit_price`, so historical sales remain correct after a product price changes.
- Change the variables at the top of files `04`, `05`, and `06` to test other thresholds, keywords, or customers.

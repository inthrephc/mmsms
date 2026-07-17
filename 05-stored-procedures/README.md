# Stored Procedure

## 1. Objective

This directory is used to store a mandatory stored procedure for the assignment.

This stored procedure demonstrates the business operation of **adding invoice details** for the Mini Mart Sales Management System.

## 2. Procedure Details

| Item | Description |
| -------- | ----- |
| Procedure Name | `dbo.sp_AddInvoiceDetail` |
| SQL File | `sp_AddInvoiceDetail.sql` |
| Business Logic | Adds a product to the invoice details. Ensures data integrity by checking stock availability and automatically accumulating the quantity if the product already exists in the invoice. |
| Input Parameters | - `@invoice_id` (`INT`): Invoice ID, `NULL` is not allowed.<br>- `@product_id` (`INT`): Product ID, `NULL` is not allowed.<br>- `@quantity` (`INT`): Quantity to purchase, `NULL` is not allowed (must be > 0). |
| Output Parameters | None. |
| Affected Tables | - **Read:** `INVOICE`, `PRODUCT`.<br>- **Insert/Update:** `INVOICE_DETAIL`. |
| Data Validation | Validates: quantity validity (> 0), invoice existence, product existence, and sufficient stock availability. |
| Expected Result | Data is inserted or updated in the `INVOICE_DETAIL` table. If any condition is violated, the system will execute a `ROLLBACK` and raise an error. |

## 3. Execution Example

```sql
EXEC dbo.sp_AddInvoiceDetail
    @invoice_id = 1,
    @product_id = 8,
    @quantity = 1
```
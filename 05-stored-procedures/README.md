# sp_AddInvoiceDetail

## Overview
The `dbo.sp_AddInvoiceDetail` Stored Procedure is used to add a product to an invoice detail. It ensures data integrity by verifying stock availability before proceeding and automatically accumulating the quantity if the product already exists in the given invoice.

## Parameters

| Parameter | Data Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `@invoice_id` | `INT` | Yes | The ID of the target invoice. |
| `@product_id` | `INT` | Yes | The ID of the selected product. |
| `@quantity` | `INT` | Yes | The quantity to be added (must be > 0). |

## Business Logic

The procedure executes the following validation and processing steps sequentially:
1. **Input Validation:** Ensures the `@quantity` parameter is strictly greater than 0.
2. **Invoice Validation:** Checks whether the `@invoice_id` exists in the `INVOICE` table.
3. **Product & Stock Validation:** Retrieves the current `stock_quantity` and `unit_price` from the `PRODUCT` table. Raises an error if the product does not exist or if the stock is insufficient to fulfill the `@quantity`.
4. **Insert / Update (Within a Transaction):**
   - If the product already exists in the invoice (`INVOICE_DETAIL` table), it **updates** the record by adding the new quantity to the existing one.
   - If the product does not exist in the invoice, it **inserts** a new record into `INVOICE_DETAIL` using the current unit price.
5. **Error Handling:** If any error occurs during the transaction, the procedure automatically executes a `ROLLBACK` to prevent data inconsistency and raises the error message.

## Usage Example

```sql
-- Example: Add 2 units of product (ID = 10) to invoice (ID = 1)
EXEC dbo.sp_AddInvoiceDetail 
    @invoice_id = 1, 
    @product_id = 10, 
    @quantity = 2;
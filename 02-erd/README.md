# Entity Relationship Diagram — Chen Notation

## 1. Entity Description

| No. | Entity     | Description                                                      |
| --: | ---------- | ---------------------------------------------------------------- |
|   1 | `CATEGORY` | Stores product category information.                             |
|   2 | `PRODUCT`  | Stores product information, price, stock quantity, and category. |
|   3 | `CUSTOMER` | Stores registered customer information.                          |
|   4 | `EMPLOYEE` | Stores employee information and identifies who creates invoices. |
|   5 | `INVOICE`  | Stores completed sales invoice information.                      |

## 2. Relationship Description

| No. | Relationship | Entities               | First → second | Second → first | Description                                                                                                                                                                                                                |
| --: | ------------ | ---------------------- | -------------- | -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   1 | `BELONGS_TO` | `CATEGORY` — `PRODUCT` | 0..N products  | 1 category     | Each product belongs to exactly one category. One category can contain zero or many products.                                                                                                                              |
|   2 | `MAKES`      | `CUSTOMER` — `INVOICE` | 0..N invoices  | 0..1 customer  | Each invoice may belong to zero or one registered customer. One customer can have zero or many invoices. If an invoice has no customer, it represents a walk-in customer.                                                |
|   3 | `CREATES`    | `EMPLOYEE` — `INVOICE` | 0..N invoices  | 1 employee     | Each invoice is created by exactly one employee. One employee can create zero or many invoices.                                                                                                                            |
|   4 | `CONTAINS`   | `INVOICE` — `PRODUCT`  | 1..N products  | 0..N invoices  | Each completed invoice contains one or more products. One product can appear in zero or many invoices. The relationship attributes `quantity` and `unit_price` become columns of `INVOICE_DETAIL` in the relational model. |

The minimum participation of one product applies to a completed invoice. Because the relational schema cannot enforce this minimum on the parent row by itself, the sales workflow is responsible for completing an invoice only after at least one detail has been added.

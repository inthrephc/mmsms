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

| No. | Relationship | Entities               | Type   | Description                                                                                                                                                                                                |
| --: | ------------ | ---------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   1 | `BELONGS_TO` | `CATEGORY` — `PRODUCT` | 1-N    | One category can have many products. Each product belongs to exactly one category.                                                                                                                         |
|   2 | `MAKES`      | `CUSTOMER` — `INVOICE` | 0..1-N | One invoice may belong to zero or one registered customer. If there is no customer, it is a walk-in customer.                                                                                              |
|   3 | `CREATES`    | `EMPLOYEE` — `INVOICE` | 1-N    | Each invoice is created by exactly one employee. One employee can create many invoices.                                                                                                                    |
|   4 | `CONTAINS`   | `INVOICE` — `PRODUCT`  | N-N    | One invoice contains one or more products. One product can appear in many invoices. This relationship has `quantity` and `unit_price`, and will become the `INVOICE_DETAIL` table in the relational model. |

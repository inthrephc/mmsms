# Mini Mart Sales Management System

Mini Mart Sales Management System is a DBI202 assignment project about designing a database system for a small retail store. The system manages products, categories, suppliers, customers, employees, invoices, invoice details, payments, and inventory.

## Repository Structure

| Folder | Purpose |
| --- | --- |
| `00-topic/` | Explains the selected topic and reason for choosing it. |
| `01-requirements/` | Lists business requirements, external entities, and system scope. |
| `02-erd/` | Contains the ERD explanation and Mermaid ER diagram source. |
| `03-relational-model/` | Converts the ERD into relational tables and provides the database schema SQL. |
| `04-data-and-queries/` | Provides sample data and __demo__ queries using SELECT, WHERE, GROUP BY, ORDER BY, JOIN, HAVING, subquery, and LIKE. |
| `05-stored-procedures/` | Contains one stored procedure __demo__. |
| `06-functions/` | Contains one SQL function __demo__. |
| `07-triggers/` | Contains one trigger __demo__ for stock and invoice total updates. |

## Suggested Execution Order

Run the SQL scripts in this order when testing the database:

1. `03-relational-model/schema.sql`
2. `07-triggers/create-trigger.sql`
3. `04-data-and-queries/seed-data.sql`
4. `05-stored-procedures/create-procedure.sql`
5. `06-functions/create-function.sql`
6. `04-data-and-queries/report-queries.sql`

The trigger is created before inserting sample invoice details so that stock quantity and invoice totals are updated automatically during the demo.

## Main Business Requirements

| No. | Requirement | Description |
| --- | --- | --- |
| 1 | Manage products | Store product information such as product name, category, supplier, unit price, and stock quantity. |
| 2 | Manage categories | Group products into categories such as food, beverage, household items, and personal care. |
| 3 | Manage suppliers | Store supplier information for products provided to the mini mart. |
| 4 | Manage customers | Store customer information for purchase tracking. |
| 5 | Manage employees | Store employee information and identify which employee creates each invoice. |
| 6 | Create invoices | Record customer purchases and invoice information. |
| 7 | Manage invoice details | Store products, quantities, and prices for each invoice. |
| 8 | Manage payments | Record payment method, payment date, and paid amount. |
| 9 | Track inventory | Update and check product stock quantity after sales. |
| 10 | Generate reports | Support queries for revenue, best-selling products, customer purchase history, and low-stock products. |

## Core Data Entities

- Category
- Supplier
- Product
- Customer
- Employee
- Invoice
- Invoice Detail
- Payment

## Expected Deliverables

- Topic explanation and reason for choosing the topic.
- Business requirements and context diagram description.
- ERD.
- Relational database model.
- SQL table creation script.
- Sample insert data.
- Query demonstrations.
- One stored procedure.
- One function.
- One trigger.

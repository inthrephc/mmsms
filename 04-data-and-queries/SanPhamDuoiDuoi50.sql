SELECT
    p.product_name,
    c.category_name,
    p.stock_quantity,
    p.unit_price
FROM PRODUCT p
JOIN CATEGORY c
ON p.category_id=c.category_id
WHERE p.stock_quantity<50;
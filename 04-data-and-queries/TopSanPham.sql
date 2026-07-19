SELECT TOP 5
    p.product_name,
    c.category_name,
    SUM(d.quantity) AS TotalSold
FROM PRODUCT p
JOIN CATEGORY c
ON p.category_id=c.category_id
JOIN INVOICE_DETAIL d
ON p.product_id=d.product_id
GROUP BY
    p.product_name,
    c.category_name
ORDER BY TotalSold DESC;

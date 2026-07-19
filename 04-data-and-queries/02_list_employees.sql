USE MiniMartSalesManagement;
GO

SELECT
    employee_id,
    full_name,
    position,
    phone,
    email,
    hire_date
FROM dbo.EMPLOYEE
ORDER BY full_name;

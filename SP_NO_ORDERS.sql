create or replace NONEDITIONABLE PROCEDURE SP_No_Orders (
    cur OUT SYS_REFCURSOR
) AS
BEGIN
 -- Selecting distinct invoice data with supplier and order details---
    OPEN cur FOR 
    SELECT 
        a.SupplierName AS "Supplier Name", 
        a.SupplierContactName, 
        a.SupplierContactNumber, 
        COUNT(b.OrderID) AS OrderCount, 
        SUM(b.OrderTotalAmount) AS TotalOrderAmount
    FROM Tbl_Suppliers a 
    INNER JOIN Tbl_Orders b ON a.SupplierId = b.SupplierId
    WHERE b.OrderDate BETWEEN TO_DATE('01-JAN-2022', 'DD-MON-YYYY') AND TO_DATE('31-AUG-2022', 'DD-MON-YYYY')
    GROUP BY 
        a.SupplierName, 
        a.SupplierContactName, 
        a.SupplierContactNumber;
        
        COMMIT;
END SP_No_Orders;
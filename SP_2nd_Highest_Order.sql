create or replace NONEDITIONABLE PROCEDURE SP_2nd_Highest_Order (
    cur OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN cur FOR 
    SELECT OrderTotalAmount,
           "Order Reference",
           "Order Period",
           "Supplier Name",
           "Invoice References"
    FROM (
        SELECT 
            SUBSTR(a.OrderRef, INSTR(a.OrderRef, 'PO') + 2) AS "Order Reference",
            a.OrderTotalAmount,
            TO_CHAR(a.OrderDate, 'Mon DD YYYY') AS "Order Period",
            UPPER(b.SupplierName) AS "Supplier Name",
            LISTAGG(c.InvoiceRef, '|') WITHIN GROUP (ORDER BY c.InvoiceRef) AS "Invoice References",
            ROW_NUMBER() OVER (ORDER BY a.OrderTotalAmount DESC) AS rn
        FROM Tbl_Orders a
        INNER JOIN Tbl_Suppliers b ON a.SupplierId = b.SupplierId
        INNER JOIN Tbl_Invoice c ON a.OrderId = c.OrderId
        GROUP BY 
            SUBSTR(a.OrderRef, INSTR(a.OrderRef, 'PO') + 2),
            a.OrderTotalAmount,
            TO_CHAR(a.OrderDate, 'Mon DD YYYY'),
            UPPER(b.SupplierName)
    ) ranked
    WHERE rn = 2;
    COMMIT;
END SP_2nd_Highest_Order;
/
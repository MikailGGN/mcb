create or replace NONEDITIONABLE PROCEDURE SP_Dist_Invoice (cur OUT SYS_REFCURSOR) AS
BEGIN
    -- Selecting distinct invoice data with supplier and order details
    OPEN cur FOR 
    SELECT DISTINCT
        -- Extracting the part after 'PO' in OrderRef
        LTRIM(SUBSTR(b.OrderRef, INSTR(b.OrderRef, 'PO') + 2)) AS "Order Reference",
        -- Formatting OrderDate to 'MMM-yyyy'
        TO_CHAR(b.OrderDate, 'MMM-yyyy') AS "Order Period", 
        -- Converting SupplierName to sentence case
        INITCAP(a.SupplierName) AS "Supplier Name",
        -- Casting OrderTotalAmount and InvoiceAmount to NUMBER
      TO_NUMBER(  CAST(b.OrderTotalAmount AS NUMBER(18, 2)),'999,999.00') AS "Order Total Amount",
        b.OrderStatus AS "Order Status",
        c.InvoiceRef AS "Invoice Reference",
       TO_NUMBER( CAST(c.InvoiceAmount AS NUMBER(18, 2)),'999,999.00') AS "Invoice Total Amount",
        -- Defining Action based on InvoiceStatus
        CASE
            WHEN c.InvoiceStatus = 'Pending' THEN 'To follow up'
            WHEN c.InvoiceStatus IS NULL OR c.InvoiceStatus = '' THEN 'To verify'
            ELSE 'OK'
        END AS Action
    FROM Tbl_Suppliers a
    INNER JOIN Tbl_Orders b ON a.SupplierId = b.SupplierId
    INNER JOIN Tbl_Invoice c ON b.OrderId = c.OrderId
    GROUP BY
        LTRIM(SUBSTR(b.OrderRef, INSTR(b.OrderRef, 'PO') + 2)),
        TO_CHAR(b.OrderDate, 'MMM-yyyy'),
        INITCAP(a.SupplierName),
       TO_NUMBER( CAST(b.OrderTotalAmount AS NUMBER(18, 2)),'999,999.00'),
        b.OrderStatus,
        c.InvoiceRef,
       TO_NUMBER( CAST(c.InvoiceAmount AS NUMBER(18, 2)),'999,999.00'),
        CASE
            WHEN c.InvoiceStatus = 'Pending' THEN 'To follow up'
            WHEN c.InvoiceStatus IS NULL OR c.InvoiceStatus = '' THEN 'To verify'
            ELSE 'OK'
        END;
END SP_Dist_Invoice;
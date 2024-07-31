create or replace NONEDITIONABLE PROCEDURE SP_InvoiceMgt AS
BEGIN
    -- Insert new invoice data into Tbl_Invoice from XXBCM_ORDER_MGT and Tbl_Orders
    INSERT INTO Tbl_Invoice (
        OrderId,
        InvoiceAmount,
        InvoiceDescription,
        InvoiceHoldReason,
        InvoiceStatus,
        InvoiceRef,
        InvoiceDate
    )
    SELECT 
        s.OrderId,
        TO_NUMBER(o.INVOICE_AMOUNT) AS InvoiceAmount,
        o.INVOICE_DESCRIPTION,
        o.INVOICE_HOLD_REASON,
        o.INVOICE_STATUS,
        o.INVOICE_REFERENCE AS InvoiceRef,
        TO_DATE(o.INVOICE_DATE, 'DD-MON-YYYY') AS InvoiceDate
    FROM XXBCM_ORDER_MGT o
    INNER JOIN Tbl_Orders s ON o.ORDER_REF = s.OrderRef
    WHERE 
        TO_NUMBER(o.INVOICE_AMOUNT) IS NOT NULL
        AND TO_DATE(o.INVOICE_DATE, 'DD-MON-YYYY') IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM Tbl_Invoice t
            WHERE t.InvoiceAmount = TO_NUMBER(o.INVOICE_AMOUNT)
              AND t.InvoiceDescription = o.INVOICE_DESCRIPTION
              AND t.InvoiceHoldReason = o.INVOICE_HOLD_REASON
              AND t.InvoiceStatus = o.INVOICE_STATUS
              AND t.InvoiceRef = o.INVOICE_REFERENCE
              AND t.InvoiceDate = TO_DATE(o.INVOICE_DATE, 'DD-MON-YYYY')
              AND t.OrderId = s.OrderId
        );
        commit;
END SP_InvoiceMgt;
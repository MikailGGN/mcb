create or replace NONEDITIONABLE procedure SP_OrderLineMgt as

BEGIN
    -- Insert new order line data into Tbl_Orders_Line from XXBCM_ORDER_MGT and Tbl_Orders

    INSERT INTO Tbl_Orders_Line (
        OrderId,
        OrderLineId,
        OrderRef,
        OrderDescription,
        OrderLineAmount,
        OrderDate
    )
    SELECT 
        s.OrderId,
        TO_NUMBER(
            REGEXP_SUBSTR(o.ORDER_REF, '[^-]+', 1, 2)
        ) AS OrderLineId,
        o.ORDER_REF,
        o.ORDER_DESCRIPTION,
        TO_NUMBER(o.ORDER_LINE_AMOUNT) AS OrderLineAmount,
        TO_DATE(o.ORDER_DATE,'DD-MON-YYYY') AS OrderDate
    FROM XXBCM_ORDER_MGT o
    INNER JOIN Tbl_Orders s ON o.ORDER_REF = s.OrderRef
    WHERE 
        TO_NUMBER(REGEXP_SUBSTR(o.ORDER_REF, '[^-]+', 1, 2)) IS NOT NULL
        AND TO_NUMBER(o.ORDER_LINE_AMOUNT) IS NOT NULL
        AND TO_DATE(o.ORDER_DATE, 'DD-MON-YYYY') IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM Tbl_Orders_Line t
            WHERE t.OrderRef = o.ORDER_REF
              AND t.OrderDescription = o.ORDER_DESCRIPTION
              AND t.OrderLineAmount = TO_NUMBER(o.ORDER_LINE_AMOUNT)
              AND t.OrderDate = TO_DATE(o.ORDER_DATE, 'DD-MON-YYYY')
              AND t.OrderId = s.OrderId
        );
        COMMIT;
END SP_OrderLineMgt;
/
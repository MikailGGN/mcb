create or replace NONEDITIONABLE PROCEDURE SP_Dist_SupplierMgt AS
BEGIN
    -- Insert distinct supplier data from XXBCM_ORDER_MGT into Tbl_Suppliers
    INSERT INTO Tbl_Suppliers (
        SupplierName,
        SupplierContactAddress,
        SupplierContactEmail,
        SupplierContactName,
        SupplierContactNumber
    )
    SELECT DISTINCT 
        SUPPLIER_NAME,
        SUPP_ADDRESS,
        SUPP_EMAIL,
        SUPP_CONTACT_NAME,
        SUPP_CONTACT_NUMBER
    FROM XXBCM_ORDER_MGT
    WHERE NOT EXISTS (
        SELECT 1
        FROM Tbl_Suppliers
        WHERE SupplierName = XXBCM_ORDER_MGT.SUPPLIER_NAME
          AND SupplierContactAddress = XXBCM_ORDER_MGT.SUPP_ADDRESS
          AND SupplierContactEmail = XXBCM_ORDER_MGT.SUPP_EMAIL
          AND SupplierContactName = XXBCM_ORDER_MGT.SUPP_CONTACT_NAME
          AND SupplierContactNumber = XXBCM_ORDER_MGT.SUPP_CONTACT_NUMBER
    );
    COMMIT;
END SP_Dist_SupplierMgt;
/
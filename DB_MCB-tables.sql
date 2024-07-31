-- Table: Tbl_Invoice
CREATE TABLE Tbl_Invoice (
    InvoiceId INT PRIMARY KEY,
    OrderId INT,
    InvoiceAmount DECIMAL(18, 2),
    InvoiceDescription VARCHAR2(2000),
    InvoiceHoldReason VARCHAR2(2000),
    InvoiceStatus VARCHAR2(2000),
    InvoiceRef VARCHAR2(2000),
    InvoiceDate DATE
);

CREATE SEQUENCE Tbl_Invoice_Seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER Tbl_Invoice_BI
BEFORE INSERT ON Tbl_Invoice
FOR EACH ROW
BEGIN
    SELECT Tbl_Invoice_Seq.NEXTVAL INTO :NEW.InvoiceId FROM DUAL;
END;
/

-- Table: Tbl_Orders
CREATE TABLE Tbl_Orders (
    OrderId INT PRIMARY KEY,
    SupplierId INT,
    OrderRef VARCHAR2(50),
    OrderStatus VARCHAR2(50),
    OrderTotalAmount DECIMAL(18, 2),
    OrderDate DATE
);

CREATE SEQUENCE Tbl_Orders_Seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER Tbl_Orders_BI
BEFORE INSERT ON Tbl_Orders
FOR EACH ROW
BEGIN
    SELECT Tbl_Orders_Seq.NEXTVAL INTO :NEW.OrderId FROM DUAL;
END;
/

-- Table: Tbl_Orders_Line
CREATE TABLE Tbl_Orders_Line (
    OrderId INT,
    OrderLineId INT,
    OrderRef VARCHAR2(50),
    OrderDescription VARCHAR2(2000),
    OrderLineAmount DECIMAL(18, 2),
    OrderDate DATE
);

-- Table: Tbl_Suppliers
CREATE TABLE Tbl_Suppliers (
    SupplierId INT PRIMARY KEY,
    SupplierName VARCHAR2(50),
    SupplierContactAddress VARCHAR2(2000),
    SupplierContactEmail VARCHAR2(50),
    SupplierContactName VARCHAR2(50),
    SupplierContactNumber VARCHAR2(50)
);

CREATE SEQUENCE Tbl_Suppliers_Seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER Tbl_Suppliers_BI
BEFORE INSERT ON Tbl_Suppliers
FOR EACH ROW
BEGIN
    SELECT Tbl_Suppliers_Seq.NEXTVAL INTO :NEW.SupplierId FROM DUAL;
END;
/

-- Foreign Key Constraints
ALTER TABLE Tbl_Invoice ADD CONSTRAINT FK_Tbl_Invoice_Tbl_Orders
FOREIGN KEY (OrderId) REFERENCES Tbl_Orders (OrderId);

ALTER TABLE Tbl_Orders ADD CONSTRAINT FK_Tbl_Orders_Tbl_Suppliers
FOREIGN KEY (SupplierId) REFERENCES Tbl_Suppliers (SupplierId);

ALTER TABLE Tbl_Orders_Line ADD CONSTRAINT FK_Tbl_Orders_Line_Tbl_Orders
FOREIGN KEY (OrderId) REFERENCES Tbl_Orders (OrderId);

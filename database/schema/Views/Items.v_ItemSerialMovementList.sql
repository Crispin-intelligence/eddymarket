SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemSerialMovementList]
AS
SELECT t.ID,
       0 AS SectionType,
       t.PurchasingID AS SectionID,
       t1.RefF,
       t1.AccountVendor,
       t1.DateOnly,
       t.SerialID
FROM Invoices.t_PurchasingDetailSerial AS t
    LEFT JOIN Invoices.t_Purchasing AS t1
        ON t1.ID = t.PurchasingID
UNION ALL
SELECT t.ID,
       1 AS SectionType,
       t.PurchasingReturnID AS SectionID,
       t1.RefF,
       t1.AccountVendor,
       t1.DateOnly,
       t.SerialID
FROM Invoices.t_PurchasingReturnDetailSerial AS t
    LEFT JOIN Invoices.t_PurchasingReturn AS t1
        ON t1.ID = t.PurchasingReturnID
UNION ALL
SELECT t.ID,
       2 AS SectionType,
       t.SoldID AS SectionID,
       t1.RefF,
       t1.AccountCustomer,
       t1.DateOnly,
       t.SerialID
FROM Invoices.t_SoldDetailSerial AS t
    LEFT JOIN Invoices.t_Sold AS t1
        ON t1.ID = t.SoldID
UNION ALL
SELECT t.ID,
       3 AS SectionType,
       t.SoldReturnID AS SectionID,
       t1.RefF,
       t1.AccountCustomer,
       t1.DateOnly,
       t.SerialID
FROM Invoices.t_SoldReturnDetailSerial AS t
    LEFT JOIN Invoices.t_SoldReturn AS t1
        ON t1.ID = t.SoldReturnID
UNION ALL
SELECT t.ID,
       158 AS SectionType,
       t.BeginningInventoryQuantityID AS SectionID,
       t1.RefF,
       '',
       CONVERT(DATE, t1.DateIs),
       t.SerialID
FROM Items.t_BeginningInventoryQuantityDetailSerial AS t
    LEFT JOIN Items.t_BeginningInventoryQuantity AS t1
        ON t1.ID = t.BeginningInventoryQuantityID;



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_InvoiceAllDetailSerialList]
AS
SELECT t.ID,
       t.PurchasingID AS InvoiceID,
       t.PurchasingDetailID AS InvoiceDetailID,
       t.SerialID,
       t1.SerialText,
       t.DateCreate
FROM Invoices.t_PurchasingDetailSerial AS t
    LEFT JOIN Items.t_ItemSerial AS t1
        ON t1.ID = t.SerialID
UNION ALL
SELECT t.ID,
       t.PurchasingReturnID,
       t.PurchasingReturnDetailID,
       t.SerialID,
       t1.SerialText,
       t.DateCreate
FROM Invoices.t_PurchasingReturnDetailSerial AS t
    LEFT JOIN Items.t_ItemSerial AS t1
        ON t1.ID = t.SerialID
UNION ALL
SELECT t.ID,
       t.SoldID,
       t.SoldDetailID,
       t.SerialID,
       t1.SerialText,
       t.DateCreate
FROM Invoices.t_SoldDetailSerial AS t
    LEFT JOIN Items.t_ItemSerial AS t1
        ON t1.ID = t.SerialID
UNION ALL
SELECT t.ID,
       t.SoldReturnID,
       t.SoldReturnDetailID,
       t.SerialID,
       t1.SerialText,
       t.DateCreate
FROM Invoices.t_SoldReturnDetailSerial AS t
    LEFT JOIN Items.t_ItemSerial AS t1
        ON t1.ID = t.SerialID;





GO

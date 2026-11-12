SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Invoices].[v_TransferDetailSerialAllList]
AS
SELECT t.ID,
       t.TransferAwaitedDetailID AS TransferDetailID,
       t1.SerialText,
       t.DateCreate
FROM Invoices.t_TransferAwaitedDetailSerial AS t
    LEFT JOIN Items.t_ItemSerial AS t1
        ON t1.ID = t.SerialID
UNION ALL
SELECT t.ID,
       t.TransferDetailID,
       t1.SerialText,
       t.DateCreate
FROM Invoices.t_TransferDetailSerial AS t
    LEFT JOIN Items.t_ItemSerial AS t1
        ON t1.ID = t.SerialID;

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_SoldReturnDetailSerialList]
AS
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

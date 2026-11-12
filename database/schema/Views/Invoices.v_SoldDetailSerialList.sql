SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Invoices].[v_SoldDetailSerialList]
AS
SELECT t.ID,
       t.SoldID,
       t.SoldDetailID,
       t.SerialID,
       t1.SerialText,
       t.DateCreate
FROM Invoices.t_SoldDetailSerial AS t
    LEFT JOIN Items.t_ItemSerial AS t1
        ON t1.ID = t.SerialID;





GO

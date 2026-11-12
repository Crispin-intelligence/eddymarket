SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_TransferAwaitedDetailSerialFillEdit]
AS
SELECT t.ID,
       t.TransferAwaitedID,
       t.TransferAwaitedDetailID,
       t.SerialID,
	   t1.SerialText
FROM Invoices.t_TransferAwaitedDetailSerial AS t
LEFT JOIN Items.t_ItemSerial AS t1
ON t1.ID = t.SerialID;

GO

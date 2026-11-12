SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_TransferDetailSerialAll]
AS
SELECT 0 AS RowIn,
       t.ID,
       t.TransferAwaitedID AS TransferID,
       t.TransferAwaitedDetailID AS TransferDetailID,
       t.SerialID,
       t.DateCreate
FROM Invoices.t_TransferAwaitedDetailSerial AS t
UNION ALL
SELECT 1 AS RowIn,
       t.ID,
       t.TransferID,
       t.TransferDetailID,
       t.SerialID,
       t.DateCreate
FROM Invoices.t_TransferDetailSerial AS t;


GO

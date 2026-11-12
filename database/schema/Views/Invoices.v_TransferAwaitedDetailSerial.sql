SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Invoices].[v_TransferAwaitedDetailSerial]
AS
SELECT t.ID,
       t.TransferAwaitedID,
       t.TransferAwaitedDetailID,
       t.SerialID,
       t.DateCreate
FROM Invoices.t_TransferAwaitedDetailSerial AS t;
GO

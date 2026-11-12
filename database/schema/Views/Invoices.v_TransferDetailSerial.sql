SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Invoices].[v_TransferDetailSerial]
AS
SELECT t.ID,
       t.TransferID,
       t.TransferDetailID,
       t.SerialID,
       t.DateCreate
FROM Invoices.t_TransferDetailSerial AS t;
GO

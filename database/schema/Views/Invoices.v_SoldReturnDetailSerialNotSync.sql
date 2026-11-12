SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_SoldReturnDetailSerialNotSync]
AS
SELECT t.ID,
       t.SoldReturnID,
       t.SoldReturnDetailID,
       t.SerialID,
       t.DateCreate
FROM Invoices.t_SoldReturnDetailSerial AS t
WHERE t.IsSync = 0;



GO

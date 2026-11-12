SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_PurchasingReturnDetailSerialNotSync]
AS
SELECT t.ID,
       t.PurchasingReturnID,
       t.PurchasingReturnDetailID,
       t.SerialID,
       t.DateCreate
FROM Invoices.t_PurchasingReturnDetailSerial AS t
WHERE t.IsSync = 0;




GO

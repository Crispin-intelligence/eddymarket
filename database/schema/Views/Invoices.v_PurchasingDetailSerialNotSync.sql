SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_PurchasingDetailSerialNotSync]
AS
SELECT t.ID,
       t.PurchasingID,
       t.PurchasingDetailID,
       t.SerialID,
       t.DateCreate
FROM Invoices.t_PurchasingDetailSerial AS t
WHERE t.IsSync = 0;



GO

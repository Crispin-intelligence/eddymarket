SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_PurchasingDetailSerial]
AS
SELECT t.ID,
       t.PurchasingID,
       t.PurchasingDetailID,
       t.SerialID,
       t.DateCreate,
	   t.IsSync
FROM Invoices.t_PurchasingDetailSerial AS t;



GO

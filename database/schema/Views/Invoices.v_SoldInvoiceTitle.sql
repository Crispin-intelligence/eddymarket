SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_SoldInvoiceTitle]
AS
SELECT t.ID,
	   t.RefPaper,
	   t.RefPurchaseOrder,
	   t.InvoiceTitle
FROM Invoices.t_Sold AS t;



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_PurchasingReturnInvoiceTitle]
AS
SELECT t.ID,
	   t.RefPaper,
	   t.InvoiceTitle
FROM Invoices.t_PurchasingReturn AS t;
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Invoices].[v_InvoiceTitle]
AS
SELECT t.ID,
       t.Name,
       t.DescriptionIs,
       t.PurchaseC,
       t.PurchaseReturnC,
       t.SellC,
       t.SellReturnC,
       t.DateCreate,
       t.IsSync
FROM Invoices.t_InvoiceTitle AS t;



GO

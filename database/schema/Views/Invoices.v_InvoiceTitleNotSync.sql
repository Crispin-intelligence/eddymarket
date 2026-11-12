SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_InvoiceTitleNotSync]
AS
SELECT  t.ID ,
        t.Name ,
        t.DescriptionIs ,
        t.PurchaseC ,
        t.PurchaseReturnC ,
        t.SellC ,
        t.SellReturnC ,
        t.SearchText ,
        t.DateCreate
FROM    Invoices.t_InvoiceTitle AS t
WHERE   t.IsSync = 0;



GO

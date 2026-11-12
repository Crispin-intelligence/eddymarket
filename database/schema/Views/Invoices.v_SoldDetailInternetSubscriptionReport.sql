SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_SoldDetailInternetSubscriptionReport]
AS
SELECT  t.ID ,
        t1.Name ,
        t1.NameInvoice ,
        t.QtyWithUnity ,
        t.TotalF ,
        t2.AccountCustomerID AS AccountID
FROM    Invoices.t_SoldDetail AS t
INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
INNER JOIN Invoices.t_Sold AS t2 ON t2.ID = t.SoldID
WHERE   t2.PaymentMethod <> 0;


GO

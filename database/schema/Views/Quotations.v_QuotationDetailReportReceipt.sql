SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Quotations].[v_QuotationDetailReportReceipt]
AS
SELECT  t.ID ,
        t.QuotationID ,
        t1.Name ,
        t1.NameInvoice ,
        t.Price ,
        t.DiscountIs ,
        t.Qty ,
        t.QtyWithUnity ,
        t2.Unity ,
        t2.PrimaryIs ,
        t.SubTotal ,
        t.SortAt
FROM    Quotations.t_QuotationDetail AS t
INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
INNER JOIN Items.t_UnityItem AS t2 ON t2.ID = t.ItemUnityID;








GO

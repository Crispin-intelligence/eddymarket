SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Items].[v_ItemSharedMaterialListItem]
AS
SELECT  t.ID ,
        t.ItemSharedFatherID ,
        t1.Name ,
        t1.Barcode ,
        t.Qtys ,
        t.QtyWithUnity ,
        t1.Purchase * t.Qtys AS Purchase ,
        Currencys.f_Format(t1.CurrencyID, t1.Purchase * t.Qtys) AS PurchaseF
FROM    Items.t_ItemSharedMaterial AS t
INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID;



GO

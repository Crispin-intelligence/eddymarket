SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ItemSharedMaterialList]
AS
SELECT  t.ID ,
        t.ItemSharedFatherID ,
        t1.Name AS NameFather ,
        t1.Barcode AS BarcodeFather ,
        t.ItemSharedID ,
        t2.Name ,
        t2.Barcode ,
        t2.Barcodes ,
        t.Qty ,
        t.QtyWithUnity ,
        t.Qtys ,
        t2.Purchase * t.Qtys AS Purchase ,
        Currencys.f_Format(t2.CurrencyID, t2.Purchase * t.Qtys) AS PurchaseF ,
        t.DescriptionIs ,
        t.DateCreate ,
        t.CreateBy
FROM    Items.t_ItemSharedMaterial AS t
INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedFatherID
INNER JOIN Items.t_ItemShared AS t2 ON t.ItemSharedID = t2.ID;






GO

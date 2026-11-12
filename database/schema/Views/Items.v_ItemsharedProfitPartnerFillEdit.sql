SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ItemsharedProfitPartnerFillEdit]
AS
SELECT  ISNULL(t1.ID, '00000000-0000-0000-0000-000000000000') AS ID ,
        t.ItemSharedID ,
        t.Name ,
        t.Barcode ,
        t.Barcodes ,
        t.CurrencyID ,
        t.Purchase ,
        t.PurchaseF ,
        t.PurchaseD ,
        t.SellCurrencyID ,
        t.Sell ,
        t.SellF ,
        t.SellD ,
        t.ProfitPartnerID ,
        t.ProfitPartner ,
        ISNULL(t1.ProfitRatio, 0) AS ProfitRatio
FROM    ( SELECT  s.ID AS ItemSharedID ,
                  s.Name ,
                  s.Barcode ,
                  s.Barcodes ,
                  s.CurrencyID ,
                  s.Purchase ,
                  s.PurchaseF ,
                  s.PurchaseD ,
                  s.SellCurrencyID ,
                  s.Sell ,
                  s.SellF ,
                  s.SellD ,
                  s1.ID AS ProfitPartnerID ,
                  s1.Name AS ProfitPartner
          FROM    Items.t_ItemShared AS s
          FULL OUTER JOIN Items.t_ProfitPartner AS s1 ON 1 = 1
        ) AS t
LEFT JOIN Items.t_ItemSharedProfitPartner AS t1 ON t1.ProfitPartnerID = t.ProfitPartnerID
                                                   AND t1.ItemSharedID = t.ItemSharedID;



GO

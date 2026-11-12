SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Items].[v_ItemsharedProfitPartnerList]
AS
SELECT  t.ID ,
        t.ItemSharedID ,
        t1.Name ,
        t1.Barcode ,
        t.ProfitPartnerID ,
        t.ProfitPartner ,
        t.ProfitRatio ,
        t.DateCreate ,
        t.IsSync
FROM    Items.t_ItemSharedProfitPartner AS t
INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID;





GO

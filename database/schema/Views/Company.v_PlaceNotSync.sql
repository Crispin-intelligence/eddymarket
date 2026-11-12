SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_PlaceNotSync]
AS
SELECT  t.ID ,
        t.Name ,
        t.WareHouseID ,
        t.WareHouse ,
        t.DescriptionIs ,
        t.ItemC ,
        t.Qtys ,
        t.Purchase ,
        t.PurchaseF ,
        t.Sell ,
        t.SellF ,
        t.SearchText ,
        t.DateCreate
FROM    Company.t_Place AS t
WHERE   t.IsSync = 0;



GO

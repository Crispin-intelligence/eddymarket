SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_WareHouseNotSync]
AS
SELECT  t.ID ,
        t.Name ,
        t.UserID ,
        t.UserIs ,
        t.Phones ,
        t.SocialMedia ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        t.BuildingID ,
        t.Building ,
        t.FloorID ,
        t.FloorIs ,
        t.PostalCodeID ,
        t.PostalCode ,
        t.AddressNote ,
        t.AddressIs ,
        t.DescriptionIs ,
        t.PhonesC ,
        t.SocialMediaC ,
        t.PlaceC ,
        t.UserC ,
        t.ItemC ,
        t.Qtys ,
        t.Purchase ,
        t.PurchaseF ,
        t.Sell ,
        t.SellF ,
        t.UsersNames ,
        t.SearchText ,
        t.DateCreate
FROM    Company.t_WareHouse AS t
WHERE   t.IsSync = 0;






GO

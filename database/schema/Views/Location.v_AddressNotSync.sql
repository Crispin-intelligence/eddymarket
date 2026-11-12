SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Location].[v_AddressNotSync]
AS
SELECT  t.ID ,
        t.SectionID ,
        t.OwnerID ,
        t.OwnerName ,
        t.Name ,
        t.TypeIs ,
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
        t.SearchText ,
        t.DateCreate
FROM    Location.t_Address AS t
WHERE   t.IsSync = 0;


GO

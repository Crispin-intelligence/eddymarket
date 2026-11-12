SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_PlaceList]
AS
SELECT  t.ID ,
        t.Name ,
        t.WareHouseID ,
        t.ItemC ,
        t.Qtys ,
        t.Purchase ,
        t.Sell ,
        t.DateCreate ,
        t.IsSync
FROM    Company.t_Place AS t;




GO

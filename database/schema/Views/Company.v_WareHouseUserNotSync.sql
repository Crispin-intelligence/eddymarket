SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_WareHouseUserNotSync]
AS
SELECT  t.ID ,
        t.WarehouseID ,
        t.Warehouse ,
        t.UserID ,
        t.UserIs ,
        t.SearchText ,
        t.DateCreate
FROM    Company.t_WareHouseUser AS t
WHERE   t.IsSync = 0;







GO

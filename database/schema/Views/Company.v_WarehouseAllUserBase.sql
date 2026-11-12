SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_WarehouseAllUserBase]
AS
SELECT t.ID AS WarehouseID,
       t.UserID,
       t.Name
FROM Company.t_WareHouse AS t
UNION
SELECT t.WarehouseID,
       t.UserID,
       t.Warehouse
FROM Company.t_WarehouseUser AS t;



GO

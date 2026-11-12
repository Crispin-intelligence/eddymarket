SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_WarehouseUserListDetail]
AS
SELECT t.ID,
       t.WarehouseID,
       t.UserIs,
       t.DateCreate
FROM Company.t_WarehouseUser AS t;




GO

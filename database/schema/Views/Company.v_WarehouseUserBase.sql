SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create VIEW [Company].[v_WarehouseUserBase]
AS
SELECT t.ID,
       t.WarehouseID,
       t.UserID
FROM Company.t_WarehouseUser AS t;




GO

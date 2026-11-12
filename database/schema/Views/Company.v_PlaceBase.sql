SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create VIEW [Company].[v_PlaceBase]
AS
SELECT t.ID,
       t.Name,
       t.WareHouseID
FROM Company.t_Place AS t


GO

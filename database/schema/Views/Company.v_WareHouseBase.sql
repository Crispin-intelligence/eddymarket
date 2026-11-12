SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_WareHouseBase]
AS
SELECT t.ID,
       t.Name
FROM Company.t_WareHouse AS t;



GO

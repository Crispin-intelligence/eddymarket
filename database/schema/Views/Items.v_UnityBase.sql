SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_UnityBase]
AS
SELECT t.ID,
       t.Name,
	   t.DateCreate
FROM Items.t_Unity AS t;




GO

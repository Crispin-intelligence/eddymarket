SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Items].[v_ItemSharedChoose1]
AS
SELECT t.ID,
       t.Name,
	   t.ImageIs,
	   t.MainCategoryID,
       t.Brand ,
       t.OrderBy
FROM Items.t_ItemShared AS t
WHERE t.StatusIs <> 2;









GO

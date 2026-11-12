SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Items].[v_MainCategoryListShortOnlyHaveItem]
AS
SELECT  t.ID ,
        t.Name ,
        t.ImageIs ,
        t.OrderBy
FROM    Items.t_MainCategory AS t
WHERE   t.ItemInListCount > 0;







GO

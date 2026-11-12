SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_SubCategoryBase]
AS
    SELECT  t.ID ,
            t.Name ,
			t.MainCategoryID
    FROM    Items.t_SubCategory AS t;
GO

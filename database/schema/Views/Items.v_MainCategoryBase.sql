SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_MainCategoryBase]
AS
SELECT t.ID,
       t.Name
FROM Items.t_MainCategory AS t;
GO

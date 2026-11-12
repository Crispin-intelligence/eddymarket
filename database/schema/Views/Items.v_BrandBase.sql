SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create VIEW [Items].[v_BrandBase]
AS
SELECT t.ID,
       t.Name
FROM Items.t_Brand AS t;


GO

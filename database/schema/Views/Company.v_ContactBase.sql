SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create VIEW [Company].[v_ContactBase]
AS
SELECT t.ID,
       t.Name,
       t.DateCreate
FROM Company.t_Contact AS t;

GO

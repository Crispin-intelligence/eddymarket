SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Users].[v_PermissionBase]
AS
SELECT t.ID,
       t.Name,
	   t.DescriptionIs,
	   t.DateCreate
FROM Users.t_Permission AS t;



GO

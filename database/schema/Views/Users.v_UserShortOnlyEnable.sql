SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Users].[v_UserShortOnlyEnable]
AS
SELECT t.ID,
       t.Name,
	   t.IsAdmin,
       t.DateCreate
FROM Users.t_User AS t
WHERE t.IsEnable = 1;




GO

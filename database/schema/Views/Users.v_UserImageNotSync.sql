SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Users].[v_UserImageNotSync]
AS
SELECT t.ID,
       t.Name,
       t.ImageIs,
       t.ImagePath,
       t.IsSyncImage
FROM Users.t_User AS t
WHERE t.IsSyncImage = 0;

GO

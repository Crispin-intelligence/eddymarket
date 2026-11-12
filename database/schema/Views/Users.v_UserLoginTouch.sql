SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Users].[v_UserLoginTouch]
AS
SELECT t.ID ,
    t.Name ,
    t.ImageIs
  FROM Users.t_User AS t
  WHERE t.UserInterfaceType = 2;





GO

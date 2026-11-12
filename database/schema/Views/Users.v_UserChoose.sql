SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Users].[v_UserChoose]
AS
SELECT  t.ID ,
        t.Name ,
        t.IsAdmin ,
        t.PermissionIs ,
        t.ImageIs ,
        t.IsEnable ,
        t.DateCreate
FROM    Users.t_User AS t;



GO

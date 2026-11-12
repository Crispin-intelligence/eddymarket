SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Users].[v_UserUserInterfaceType]
AS
SELECT  t.ID ,
        t.Name ,
        t.IsAdmin ,
        t.UserInterfaceType ,
        t.AccountBoxID ,
        t.AccountBoxName ,
        t.AccountBoxLLID ,
        t.AccountBoxLLName ,
        t.AccountBoxEuroID ,
        t.AccountBoxEuroName
FROM    Users.t_User AS t;









GO

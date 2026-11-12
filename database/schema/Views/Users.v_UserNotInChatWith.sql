SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Users].[v_UserNotInChatWith]
AS
SELECT        t.ID, t.Name, t.ImageIs, t.IsOnline
FROM            Users.t_User AS t 





GO

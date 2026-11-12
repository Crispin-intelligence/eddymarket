SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Users].[v_ChatWith]
AS
    SELECT  t.ID ,
            t.UserID ,
            t.ChatWithID ,
            t.IsPin ,
            t.IsUnread ,
            t.LastChat ,
            t.LastType ,
            t.LastText ,
            Users.f_ChatGetCountUnReadWithUser(t.UserID, t.ChatWithID) AS CountUnread
    FROM    Users.t_ChatWith AS t;




GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Users].[v_ChatHistory]
AS
    SELECT  t.ID ,
            t.FromUserID ,
            t.ToUserID ,
            t.TypeIs ,
            t.TextIs ,
            t.DataIs ,
            t.SendIn ,
            t.ReadIn ,
            t.FromIsDeleted ,
            t.ToIsDeleted
    FROM    Users.t_ChatHistory AS t;





GO

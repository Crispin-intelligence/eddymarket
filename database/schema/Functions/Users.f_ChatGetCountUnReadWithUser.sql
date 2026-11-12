SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Users].[f_ChatGetCountUnReadWithUser] ( @ID INT,
                                                         @CharWith INT )
RETURNS BIGINT
AS
    BEGIN

        RETURN COALESCE((SELECT COUNT(*) FROM Users.t_Chat AS t WHERE t.FromUserID = @CharWith AND t.ToUserID = @ID AND t.ReadIn IS NULL) , 0);

    END;



GO

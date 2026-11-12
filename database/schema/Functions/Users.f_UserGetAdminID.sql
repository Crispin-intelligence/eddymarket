SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Users].[f_UserGetAdminID] ( )
RETURNS UNIQUEIDENTIFIER
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @ID UNIQUEIDENTIFIER;

  END;

  BEGIN --Set

    SELECT TOP ( 1 ) @ID = ID
      FROM Users.t_User AS t
      WHERE t.IsAdmin = 1
      ORDER BY t.DateCreate;

  END;

  RETURN @ID;

END;













GO

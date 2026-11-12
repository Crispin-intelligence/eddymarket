SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Users].[f_UserSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			CONVERT(NVARCHAR(MAX), ID) + ', ' + 
			LOWER(Name) + ', ' + 
			LOWER(PasswordIs) + ', ' + 
			CONVERT(NVARCHAR(MAX), PermissionID) + ', ' + 
			LOWER(PermissionIs) + ', ' + 
			CONVERT(NVARCHAR(MAX), AccountBoxID) + ', ' + 
			LOWER(AccountBoxName) + ', ' + 
			AccountBoxNumberF + ', ' + 
			BeginWorkF + ', ' + 
			EndWorkF + ', ' + 
			FORMAT(TemporaryDate, N'dd-MM-yyyy hh:mm tt') +
			WorkTime + ', ' + 
			FORMAT(LoginC, N'0') + ', ' + 
			FORMAT(AccountBlockedC, N'0') + ', ' + 
			LOWER(AccountNames) + ', ' + 
			FORMAT(DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Users.t_User AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;









GO

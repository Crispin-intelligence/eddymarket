SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountExpenseGetFirstID] ( )
RETURNS UNIQUEIDENTIFIER
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @ID UNIQUEIDENTIFIER;

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @ID = ID
    FROM    Company.t_Account AS t
    WHERE   t.NumberIs BETWEEN 6260100000 AND 6269999999
    ORDER BY t.DateCreate;

  END;

  RETURN ISNULL(@ID,'00000000-0000-0000-0000-000000000000');

END;














GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountBoxGetFirstName] ()
RETURNS NVARCHAR(max)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @Name NVARCHAR(max);

    END;

    BEGIN --Set

        SELECT TOP (1)
               @Name = t.Name
        FROM Company.t_Account AS t
		WHERE t.NumberIs BETWEEN 5310100000 AND 5310199999	
        ORDER BY t.DateCreate;

    END;

    RETURN @Name;

END;













GO

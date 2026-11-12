SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Customers].[f_AgeRangeGetFirstName] ( )
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @Name NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT TOP ( 1 )
                @Name = t.Name
        FROM    Customers.t_AgeRange AS t
        ORDER BY t.DateCreate;

    END;
	
    RETURN ISNULL(@Name, '');

END;



GO

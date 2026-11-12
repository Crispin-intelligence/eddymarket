SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountVendorGetFirstName] ()
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @Name NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT TOP (1)
               @Name = t.Name
        FROM Company.t_Account AS t
        WHERE t.NumberIs
        BETWEEN 4010100000 AND 4010199999
        ORDER BY t.DateCreate;

    END;

    RETURN @Name;

END;














GO

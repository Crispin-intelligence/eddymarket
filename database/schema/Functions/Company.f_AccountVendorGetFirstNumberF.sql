SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountVendorGetFirstNumberF] ()
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @NumberF NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT TOP (1)
               @NumberF = t.NumberF
        FROM Company.t_Account AS t
        WHERE t.NumberIs
        BETWEEN 4010100000 AND 4010199999
        ORDER BY t.DateCreate;

    END;

    RETURN @NumberF;

END;














GO

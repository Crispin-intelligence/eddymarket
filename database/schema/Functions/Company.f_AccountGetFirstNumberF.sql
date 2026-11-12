SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountGetFirstNumberF] ()
RETURNS NVARCHAR(max)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @NumberF NVARCHAR(max);

    END;

    BEGIN --Set

        SELECT TOP (1)
               @NumberF = t.NumberF
        FROM Company.t_Account AS t
        ORDER BY t.DateCreate;

    END;

    RETURN @NumberF;

END;












GO

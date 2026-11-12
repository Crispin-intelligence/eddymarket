SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountSalesGetFirstNumberF] ()
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
		WHERE t.NumberIs BETWEEN 7010100000 AND 7010199999	
        ORDER BY t.DateCreate;

    END;

    RETURN @NumberF;

END;













GO

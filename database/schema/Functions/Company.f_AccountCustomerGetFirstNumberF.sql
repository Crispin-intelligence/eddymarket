SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountCustomerGetFirstNumberF] ()
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
		WHERE t.NumberIs BETWEEN 4110100000 AND 4110199999	
        ORDER BY t.DateCreate;

    END;

    RETURN @NumberF;

END;















GO

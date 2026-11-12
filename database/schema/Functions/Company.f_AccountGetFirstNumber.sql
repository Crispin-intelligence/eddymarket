SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountGetFirstNumber] ()
RETURNS BIGINT
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @NumberIs BIGINT;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @NumberIs = t.NumberIs
        FROM Company.t_Account AS t
        ORDER BY t.DateCreate;

    END;

    RETURN @NumberIs;

END;












GO

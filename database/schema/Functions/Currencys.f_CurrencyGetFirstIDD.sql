SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [Currencys].[f_CurrencyGetFirstIDD] ()
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @ID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @ID = ID
        FROM Currencys.t_Currency AS t
		WHERE t.TypeIs = 0
        ORDER BY t.DateCreate;

    END;

    RETURN @ID;

END;












GO

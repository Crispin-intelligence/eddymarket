SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [Currencys].[f_CurrencyGetFirstTypeIs] ()
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @TypeIs INT;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @TypeIs = t.TypeIs
        FROM Currencys.t_Currency AS t
        ORDER BY t.DateCreate;

    END;

    RETURN COALESCE(@TypeIs, 0);

END;




GO

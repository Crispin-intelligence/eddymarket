SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Currencys].[f_CurrencyGetFirstExchangeRate] ()
RETURNS DECIMAL(18, 2)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @ExchangeRate DECIMAL(18, 2);

    END;

    BEGIN --Set

        SELECT TOP (1)
               @ExchangeRate = t.ExchangeRate
        FROM Currencys.t_Currency AS t
        ORDER BY t.DateCreate;

    END;

    RETURN @ExchangeRate;

END;











GO

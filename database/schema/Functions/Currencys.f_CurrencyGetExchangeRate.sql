SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Currencys].[f_CurrencyGetExchangeRate]
(
    @ID UNIQUEIDENTIFIER
)
RETURNS DECIMAL(18, 2)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @ExchangeRate DECIMAL(18, 2);

    END;

    BEGIN --Set

        SELECT @ExchangeRate = t.ExchangeRate
        FROM Currencys.t_Currency AS t
        WHERE t.ID = @ID;

    END;

    RETURN COALESCE(@ExchangeRate, 1);

END;



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Currencys].[f_ExchangeToAccountCurrency]
(
    @CurrencyID UNIQUEIDENTIFIER,
    @ExchangeRate DECIMAL(18, 2),
    @Price FLOAT,
    @AccountCurrencyID UNIQUEIDENTIFIER
)
RETURNS FLOAT
BEGIN

    BEGIN --DECLARE

        DECLARE @PriceD FLOAT = @Price / @ExchangeRate;

    END;

    IF @CurrencyID = @AccountCurrencyID --Check some currency
    BEGIN

        RETURN @Price;

    END;



    BEGIN --Declare

        DECLARE @ExchangeRateCurrency DECIMAL(18, 2);

    END;

    BEGIN --Set Info

        SELECT @ExchangeRateCurrency = ExchangeRate
        FROM Currencys.t_Currency
        WHERE ID = @AccountCurrencyID;

    END;

    RETURN @PriceD * @ExchangeRateCurrency;

END;




GO

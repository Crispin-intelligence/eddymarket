SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Currencys].[f_ExchangeToEuro]
(
    @FromCurrenyID UNIQUEIDENTIFIER,
    @Price FLOAT,
    @PriceD FLOAT
)
RETURNS FLOAT
BEGIN

    BEGIN --Check same currency

        IF EXISTS
        (
            SELECT TOP (1)
                   s.ID
            FROM Currencys.t_Currency AS s
            WHERE s.ID = @FromCurrenyID
                  AND s.TypeIs = 2
        )
        BEGIN
            RETURN @Price;
        END;

    END;

    BEGIN --DECLARE

        DECLARE @ExchangeRate DECIMAL(18, 2);

    END;

    BEGIN --Set info

        SELECT @ExchangeRate = t.ExchangeRate
        FROM Currencys.t_Currency
AS          t
        WHERE t.TypeIs = 2;

    END;

    RETURN @PriceD * @ExchangeRate;

END;

GO

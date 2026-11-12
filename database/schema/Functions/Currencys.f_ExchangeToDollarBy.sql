SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Currencys].[f_ExchangeToDollarBy]
(
    @ID UNIQUEIDENTIFIER,
    @PriceD FLOAT
)
RETURNS FLOAT
BEGIN

    BEGIN --Declare

        DECLARE @ExchangeRate DECIMAL(18, 2);

    END;

    BEGIN --Set Info

        SELECT @ExchangeRate = ExchangeRate
        FROM Currencys.t_Currency
        WHERE ID = @ID;

    END;

    RETURN @PriceD * @ExchangeRate;

END;


GO

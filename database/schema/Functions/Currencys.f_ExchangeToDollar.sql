SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Currencys].[f_ExchangeToDollar]
(
    @ExchangeRate DECIMAL(18, 2),
    @Price FLOAT
)
RETURNS FLOAT
BEGIN

    RETURN @Price / @ExchangeRate;

END;

GO

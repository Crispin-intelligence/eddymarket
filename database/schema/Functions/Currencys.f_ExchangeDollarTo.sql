SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Currencys].[f_ExchangeDollarTo]
(
    @ExchangeRate DECIMAL(18, 2),
    @PriceD FLOAT
)
RETURNS FLOAT
BEGIN

    RETURN @PriceD * @ExchangeRate;

END;

GO

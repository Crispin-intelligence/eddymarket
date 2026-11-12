SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Items].[f_ItemSharedGetInventoryBalance]
(
    @CurrencyType TINYINT
)
RETURNS FLOAT
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @v FLOAT = 0;

    END;

    IF @CurrencyType = 0
    BEGIN --Set D

        SELECT @v = COALESCE(SUM(t.PurchaseTotalWithTaxD), 0)
        FROM Items.t_ItemShared AS t;

    END;
    ELSE IF @CurrencyType = 1
    BEGIN --Set LL

        SELECT @v = COALESCE(SUM(t.PurchaseTotalWithTaxLL), 0)
        FROM Items.t_ItemShared AS t;

    END;
    ELSE IF @CurrencyType = 2
    BEGIN --Set Euro

        SELECT @v = COALESCE(SUM(t.PurchaseTotalWithTaxEuro), 0)
        FROM Items.t_ItemShared AS t;

    END;

    RETURN @v;

END;


GO

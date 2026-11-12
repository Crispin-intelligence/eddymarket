SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountGetCurrency]
(
    @ID UNIQUEIDENTIFIER
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @CurrencyID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set

        SELECT @CurrencyID = t.CurrencyID
        FROM Company.t_Account AS t
        WHERE t.ID = @ID;

    END;

    RETURN @CurrencyID;

END;





GO

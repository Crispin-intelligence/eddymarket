SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Items].[f_UnityItemGetCurrencyID]
(
    @ItemSharedID UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @CurrencyID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @CurrencyID = t.CurrencyID
        FROM Items.t_UnityItem AS t
        WHERE t.SharedID = @ItemSharedID
              AND t.PrimaryIs = 1
        ORDER BY t.DateCreate;

    END;

    RETURN @CurrencyID;

END;












GO

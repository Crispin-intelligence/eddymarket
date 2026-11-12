SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Currencys].[f_CurrencyGetTypeIs]
(
    @ID UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @TypeIs INT;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @TypeIs = t.TypeIs
        FROM Currencys.t_Currency AS t
        WHERE t.ID = @ID
        ORDER BY t.ID;

    END;

    RETURN COALESCE(@TypeIs, 0);

END;





GO

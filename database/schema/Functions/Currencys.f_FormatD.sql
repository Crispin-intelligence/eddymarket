SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Currencys].[f_FormatD]
(
    @Price DECIMAL(36, 6)
)
RETURNS NVARCHAR(MAX)
BEGIN

    BEGIN --Declare

        DECLARE @Name NVARCHAR(MAX),
                @DisplayFormat2 NVARCHAR(MAX);

    END;

    BEGIN --Set Info

        SELECT TOP (1)
               @Name = Name,
               @DisplayFormat2 = DisplayFormat2
        FROM Currencys.t_Currency
        WHERE TypeIs = 0
        ORDER BY ID;

    END;

    RETURN FORMAT(@Price, @DisplayFormat2) + ' ' + @Name;

END;





GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Currencys].[f_Format]
(
    @ID UNIQUEIDENTIFIER,
    @Price DECIMAL(36, 6)
)
RETURNS NVARCHAR(MAX)
BEGIN

    BEGIN --Declare

        DECLARE @Name NVARCHAR(MAX),
                @DisplayFormat2 NVARCHAR(MAX);

    END;

    BEGIN --Set Info

        SELECT @Name = t.Name,
               @DisplayFormat2 = t.DisplayFormat2
        FROM Currencys.t_Currency AS t
        WHERE t.ID = @ID;

    END;

    RETURN FORMAT(@Price, @DisplayFormat2) + ' ' + @Name;

END;


GO

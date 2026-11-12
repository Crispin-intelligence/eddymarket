SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Alls].[f_LanguageCodeGetName]
(
    @ID UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @Name NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT @Name = t.Name
        FROM Alls.t_LanguageCode AS t
        WHERE t.ID = @ID;

    END;

    RETURN COALESCE(@Name, '');

END;



GO

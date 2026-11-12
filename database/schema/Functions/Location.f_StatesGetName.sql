SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Location].[f_StatesGetName]
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
        FROM Location.t_States AS t
        WHERE t.ID = @ID;

    END;

    RETURN COALESCE(@Name, '');

END;






GO

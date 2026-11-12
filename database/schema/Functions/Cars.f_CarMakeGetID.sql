SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Cars].[f_CarMakeGetID]
(
    @Name NVARCHAR(MAX)
)
RETURNS UNIQUEIDENTIFIER 
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @ID NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT @ID = t.ID
        FROM Cars.t_CarMake AS t
        WHERE t.Name = @Name;

    END;

    RETURN COALESCE(@ID, '00000000-0000-0000-0000-000000000000');

END;







GO

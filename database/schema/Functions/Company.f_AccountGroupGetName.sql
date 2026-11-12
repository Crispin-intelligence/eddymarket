SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [Company].[f_AccountGroupGetName]
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
        FROM Company.t_AccountGroup AS t
        WHERE t.ID = @ID;

    END;

    RETURN COALESCE(@Name, '');

END;






GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Customers].[f_AgeRangeGetName] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @Name NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT  @Name = t.Name
        FROM    Customers.t_AgeRange AS t
        WHERE   t.ID = @ID;

    END;

    RETURN ISNULL(@Name, '');

END;


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountIsVendor]
(
    @ID UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN

    IF EXISTS
    (
        SELECT TOP (1)
               t.ID
        FROM Company.t_Account AS t
        WHERE t.ID = @ID
              AND t.SectionID = 67
        ORDER BY t.DateCreate
    )
    BEGIN --Set

        RETURN 1;

    END;

    RETURN 0;

END;













GO

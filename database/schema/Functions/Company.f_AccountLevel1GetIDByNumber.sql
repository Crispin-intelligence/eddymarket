SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountLevel1GetIDByNumber]
(
    @NumberIs BIGINT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @ID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @ID = ID
        FROM Company.t_AccountLevel1 AS t
        WHERE t.NumberIs = @NumberIs
        ORDER BY t.DateCreate;

    END;

    RETURN @ID;

END;











GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create FUNCTION [Company].[f_AccountLevel3GetNumberIs]
(
    @ID UNIQUEIDENTIFIER
)
RETURNS BIGINT
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @NumberIs BIGINT;

    END;

    BEGIN --Set

        SELECT @NumberIs = t.NumberIs
        FROM Company.t_AccountLevel3 AS t
        WHERE t.ID = @ID;

    END;

    RETURN COALESCE(@NumberIs, 0);

END;


GO

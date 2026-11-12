SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountGetNumber]
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
        FROM Company.t_Account AS t
        WHERE t.ID = @ID;

    END;

    RETURN @NumberIs;

END;












GO

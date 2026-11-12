SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountGetNumberF]
(
    @ID UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @NumberF NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT @NumberF = t.NumberF
        FROM Company.t_Account AS t
        WHERE t.ID = @ID;

    END;

    RETURN COALESCE(@NumberF, N'');

END;













GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create FUNCTION [Alls].[f_GetOneAtLess]
(
    @v NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    SET @v = RTRIM(LTRIM(@v));

    IF @v = ''
    BEGIN

        SET @v = '-';

    END;

    RETURN @v;

END;

GO

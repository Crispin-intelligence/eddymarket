SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [Alls].[f_AppendWithParentheses]
(
    @v NVARCHAR(MAX),
    @NewValue NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    SET @NewValue = RTRIM(LTRIM(@NewValue));

    IF @NewValue = ''
    BEGIN

        RETURN @v;

    END;
	
    RETURN @v + ' (' + @NewValue + ')';

END;


GO

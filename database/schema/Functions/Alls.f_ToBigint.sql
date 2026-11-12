SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Alls].[f_ToBigint]
(
    @v NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
BEGIN

    DECLARE @OutPut BIGINT;

    SET @OutPut
        = SUBSTRING(@v, PATINDEX('%[0-9]%', @v), PATINDEX('%[0-9][^0-9]%', @v + 't') - PATINDEX('%[0-9]%', @v) + 1);

    RETURN ISNULL(@OutPut, 0);

END;


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Currencys].[f_FormatRate]
(
    @Value DECIMAL(38, 2)
)
RETURNS NVARCHAR(MAX)
BEGIN

    RETURN FORMAT(COALESCE(@Value, 0), '#,##0.##') + N' %';

END;




GO

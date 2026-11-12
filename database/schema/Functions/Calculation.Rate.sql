SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Calculation].[Rate]  
(
    @Value FLOAT,
    @Rate DECIMAL(18, 2)
) 
RETURNS FLOAT

AS
BEGIN

    RETURN @Value + ((@Value / 100) * @Rate);

END;




GO

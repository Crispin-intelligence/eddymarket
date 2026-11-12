SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION	[Calculation].[Discount](@Value FLOAT , @DiscountRate DECIMAL(18,2)) RETURNS FLOAT
AS
BEGIN
	RETURN @Value - ((@Value / 100) * @DiscountRate)
END



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Items].[f_UnityItemSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			CONVERT(NVARCHAR(MAX), ID) + ', ' + 
			CONVERT(NVARCHAR(MAX), UnityID) + ', ' + 
			LOWER(Unity) + ', ' + 
			CONVERT(NVARCHAR(MAX), SharedID) + ', ' + 
			FORMAT(Qty, N'0.##') + ', ' + 
			FORMAT(QtyCurrent, N'0.####') + ', ' + 
			LOWER(BarCode) + ', ' + 
			CONVERT(NVARCHAR(MAX), CurrencyID) + ', ' + 
			LOWER(Currency) + ', ' + 
			LOWER(PriceF) + ', ' + 
			LOWER(PriceWithTaxF) + ', ' + 
			LOWER(LowestPriceF) + ', ' + 
			CONVERT(NVARCHAR(MAX), CurrencyIDCost) + ', ' + 
			LOWER(CurrencyCost) + ', ' + 
			LOWER(CostF) + ', ' + 
			LOWER(CostWithTaxF) + ', ' + 
			FORMAT(DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Items.t_UnityItem AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;








GO

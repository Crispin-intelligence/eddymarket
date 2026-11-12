SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_PlaceSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			CONVERT(NVARCHAR(MAX), t.ID) + ', ' + 
			LOWER(t.Name) + ', ' + 
			LOWER(t.Warehouse) + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.ItemC, N'0') + ', ' + 
			FORMAT(t.Qtys, N'0.##') + ', ' + 
			FORMAT(t.Purchase, N'0.####') + ', ' + 
			LOWER(t.PurchaseF) + ', ' + 
			FORMAT(t.Sell, N'0.####') + ', ' + 
			LOWER(t.SellF) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Company.t_Place AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;


GO

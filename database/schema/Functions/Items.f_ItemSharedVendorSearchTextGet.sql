SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Items].[f_ItemSharedVendorSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			CONVERT(NVARCHAR(MAX), SharedID) + ', ' + 
			CONVERT(NVARCHAR(MAX), VendorID) + ', ' + 
			LOWER(ItemCode) + ', ' + 
			LOWER(UnitIs) + ', ' + 
			CONVERT(NVARCHAR(MAX), CurrencyID) + ', ' + 
			LOWER(Currency) + ', ' + 
			FORMAT(Price, N'0.##') + ', ' +
			LOWER(PriceF) + ', ' + 
			LOWER(DescriptionIs) + ', ' + 
			FORMAT(DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Items.t_ItemSharedVendor AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;











GO

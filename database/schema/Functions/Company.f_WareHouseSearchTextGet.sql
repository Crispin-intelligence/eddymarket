SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_WareHouseSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.UserIs) + ', ' + 
			LOWER(t.Phones) + ', ' + 
			LOWER(t.SocialMedia) + ', ' + 
			LOWER(t.StatesIs) + ', ' + 
			LOWER(t.RegionIs) + ', ' + 
			LOWER(t.Street) + ', ' + 
			LOWER(t.Building) + ', ' + 
			LOWER(t.FloorIs) + ', ' + 
			LOWER(t.PostalCode) + ', ' + 
			LOWER(t.AddressNote) + ', ' + 
			LOWER(t.AddressIs) + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			LOWER(t.PurchaseF) + ', ' + 
			LOWER(t.SellF) + ', ' + 
			LOWER(t.UsersNames) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Company.t_WareHouse AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;













GO

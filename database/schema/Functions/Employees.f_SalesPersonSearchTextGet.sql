SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Employees].[f_SalesPersonSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			CONVERT(NVARCHAR(MAX), t1.ID) + ', ' + 
			LOWER(t1.Name) + ', ' + 
			FORMAT(t1.NumberIs, N'0') + ', ' + 
			FORMAT(t1.Balance, N'0.####') + ', ' + 
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
			FORMAT(t.CommissionAvailableValueD, N'0.####') + ', ' + 
			FORMAT(t.CommissionAvailableValueLL, N'0.####') + ', ' + 
			FORMAT(t.CommissionAvailableValueEuro, N'0.####') + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			LOWER(t.WhyThisStatus) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Employees.t_SalesPerson AS t
    INNER  JOIN Company.t_Account AS t1 ON t.ID = t1.LinkWithID
                                           AND t1.SectionID = 149
                                           AND t1.NumberIs BETWEEN 4610100000 AND 4610199999
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;










GO

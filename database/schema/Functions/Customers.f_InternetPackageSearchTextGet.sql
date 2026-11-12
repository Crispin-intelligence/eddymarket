SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Customers].[f_InternetPackageSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.Currency) + ', ' + 
			LOWER(t.CostF) + ', ' + 
			LOWER(t.PriceF) + ', ' + 
			LOWER(t.ProfitF) + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.TotalCustomers, N'0') + ', ' + 
			FORMAT(t.TotalSubscriptions, N'0') + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Customers.t_InternetPackage AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;










GO

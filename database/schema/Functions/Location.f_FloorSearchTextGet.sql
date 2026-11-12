SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Location].[f_FloorSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(Name) + ', ' + 
			LOWER(DescriptionIs) + ', ' + 
			FORMAT(AddressC, N'0') + ', ' + 
			FORMAT(BankC, N'0') + ', ' + 
			FORMAT(ContactC, N'0') + ', ' + 
			FORMAT(CustomerC, N'0') + ', ' + 
			FORMAT(EmployeeC, N'0') + ', ' + 
			FORMAT(SalesPersonC, N'0') + ', ' + 
			FORMAT(VendorC, N'0') + ', ' + 
			FORMAT(WarehouseC, N'0') + ', ' + 
			FORMAT(DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Location.t_Floor AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;








GO

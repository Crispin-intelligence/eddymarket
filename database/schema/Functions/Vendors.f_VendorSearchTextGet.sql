SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Vendors].[f_VendorSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.Phones) + ', ' + 
			LOWER(t.SocialMedia) + ', ' +  
			LOWER(t.Title) + ', ' + 
			LOWER(t.Classification) + ', ' + 
			LOWER(t.AddressIs) + ', ' + 
			LOWER(t.NumberCurrency) + ', ' + 
			LOWER(t.CallAfterF) + ', ' +
			LOWER(t.DescriptionIs) + ', ' + 
			LOWER(t.AdditionalProperty1) + ', ' + 
			LOWER(t.AdditionalProperty2) + ', ' + 
			LOWER(t.AdditionalProperty3) + ', ' + 
			LOWER(t.AdditionalProperty4) + ', ' + 
			LOWER(t.AdditionalProperty5) + ', ' + 
			LOWER(t.AdditionalProperty6) + ', ' + 
			LOWER(t.AdditionalProperty7) + ', ' + 
			LOWER(t.AdditionalProperty8) + ', ' + 
			LOWER(t.AdditionalProperty9) + ', ' + 
			LOWER(t.AdditionalProperty10) + ', ' + 
			LOWER(t.WhyThisStatus) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Vendors.t_Vendor AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;











GO

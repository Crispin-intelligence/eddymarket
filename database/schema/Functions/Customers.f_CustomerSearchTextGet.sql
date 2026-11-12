SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Customers].[f_CustomerSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.IDNumber) + ', ' + 
			FORMAT(t.IDDoor, N'0') + ', ' + 
			LOWER(t.Name) + ', ' + 
			LOWER(t.NameAR) + ', ' + 
			LOWER(t.Reference) + ', ' + 
			LOWER(t.Phones) + ', ' + 
			LOWER(t.SocialMedia) + ', ' +  
			FORMAT(t.Birthday, N'dd-MM-yyyy') + ', ' + 
			LOWER(t.AgeIs) + ', ' + 
			LOWER(t.AgeRange) + ', ' + 
			LOWER(t.Title) + ', ' + 
			LOWER(t.Classification) + ', ' + 
			LOWER(t.SalesPerson) + ', ' + 
			LOWER(t.Nationality) + ', ' + 
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
			LOWER(t.EmployeeInternet) + ', ' + 
			LOWER(t.InternetPackage) + ', ' +  
			LOWER(t.UserNameInternet) + ', ' +   
			LOWER(t.InternetSubscriptionTotalF) + ', ' + 
			LOWER(t.InternetSubscriptionProfitF) + ', ' + 
			LOWER(t.MaximumDebtInvoiceF) + ', ' + 
			LOWER(t.GroupNames) + ', ' + 
			LOWER(t.PrescriptionDoctor) + ', ' + 
			LOWER(t.PrescriptionBrand) + ', ' + 
			LOWER(t.PrescriptionTypeIs) + ', ' + 
			LOWER(t.PrescriptionFocal) + ', ' + 
			LOWER(t.PrescriptionBaseRight) + ', ' + 
			LOWER(t.PrescriptionBaseLeft) + ', ' + 
			LOWER(t.PrescriptionDescriptionIs) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Customers.t_Customer AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;










GO

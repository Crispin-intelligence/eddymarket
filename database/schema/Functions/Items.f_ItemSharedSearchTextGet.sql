SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Items].[f_ItemSharedSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			LOWER(Name) + ', ' + 
			LOWER(NameInvoice) + ', ' + 
			LOWER(Barcodes) + ', ' + 
			LOWER(MainCategory) + ', ' + 
			LOWER(SubCategory) + ', ' + 
			LOWER(Brand) + ', ' + 
			FORMAT(QtyCurrent, N'0') + ', ' + 
			LOWER(SizeIs) + ', ' + 
			LOWER(ColorIs) + ', ' + 
			LOWER(Currency) + ', ' + 
			LOWER(PurchaseF) + ', ' + 
			LOWER(PurchaseWithTaxF) + ', ' + 
			LOWER(SellF) + ', ' + 
			LOWER(SellWithTaxF) + ', ' + 
			LOWER(DescriptionAR) + ', ' + 
			LOWER(DescriptionEN) + ', ' +  
			LOWER(DescriptionSearch) + ', ' +  
			LOWER(DescriptionIs) + ', ' +  
			LOWER(UnityNames) + ', ' +  
			LOWER(VendorNames) + ', ' +  
			LOWER(AdditionalProperty1) + ', ' +  
			LOWER(AdditionalProperty2) + ', ' +  
			LOWER(AdditionalProperty3) + ', ' +  
			LOWER(AdditionalProperty4) + ', ' +  
			LOWER(AdditionalProperty5) + ', ' +  
			LOWER(AdditionalProperty6) + ', ' +  
			LOWER(AdditionalProperty7) + ', ' +  
			LOWER(AdditionalProperty8) + ', ' +  
			LOWER(AdditionalProperty9) + ', ' +  
			LOWER(AdditionalProperty10) + ', ' +  
			FORMAT(DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Items.t_ItemShared AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;










GO

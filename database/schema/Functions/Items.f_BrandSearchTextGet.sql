SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Items].[f_BrandSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			FORMAT(ItemC, N'0') + ', ' + 
			FORMAT(PurchaseC, N'0') + ', ' + 
			FORMAT(PurchaseQty, N'0') + ', ' + 
			FORMAT(PurchaseReturnC, N'0') + ', ' + 
			FORMAT(PurchaseReturnQty, N'0') + ', ' + 
			FORMAT(SellC, N'0') + ', ' + 
			FORMAT(SellQty, N'0') + ', ' + 
			FORMAT(SellReturnC, N'0') + ', ' + 
			FORMAT(SellReturnQty, N'0') + ', ' + 
			FORMAT(QuotationC, N'0') + ', ' + 
			FORMAT(QuotationQty, N'0') + ', ' + 
			FORMAT(DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Items.t_Brand AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;







GO

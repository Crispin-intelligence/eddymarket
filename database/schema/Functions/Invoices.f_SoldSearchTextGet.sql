SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_SoldSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			FORMAT(t.Ref,N'n0') + ', ' + 
			LOWER(t.RefF) + ', ' + 
			LOWER(t.RefPaper) + ', ' + 
			LOWER(t.RefPurchaseOrder) + ', ' + 
			LOWER(t.QuotationRef) + ', ' + 
			LOWER(t.InvoiceTitle) + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.DateIs, N'dd-MM-yyyy hh:mm tt') + ', ' + 
			LOWER(t.UserIs) + ', ' + 
			LOWER(t.Salesperson) + ', ' +
			LOWER(t.AccountCustomer) + ', ' +
			LOWER(t.AccountCustomerNumber) + ', ' +
			LOWER(t.AccountBox) + ', ' +
			LOWER(t.AccountBoxNumber) + ', ' +
			LOWER(t.DescriptionIs) + ', ' +
			LOWER(t.FrameJobOrderRefF) + ', ' +
			LOWER(t.ItemsNames) + ', ' +
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Invoices.t_Sold AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Items].[f_ProfitPartnerSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			LOWER(t.Name) + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.ItemsCount, N'0') + ', ' + 
			FORMAT(t.SalesInvoicesCount, N'0') + ', ' + 
			FORMAT(TotalProfitD, N'0.####') + ', ' + 
			FORMAT(TotalProfitLL, N'0.####') + ', ' + 
			FORMAT(TotalProfitEuro, N'0.####') + ', ' + 
			FORMAT(DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Items.t_ProfitPartner AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;











GO

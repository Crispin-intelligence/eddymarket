SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Cars].[f_CarExpenseSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.RefF) + ', ' + 
			FORMAT(t.DateIs, N'dd-MM-yyyy hh:mm tt') + 
			LOWER(t.ByUser) + ', ' + 
			LOWER(t.FromAccount) + ', ' + 
			LOWER(t.FromAccountNumberF) + ', ' + 
			LOWER(t.ToAccount) + ', ' + 
			LOWER(t.ToAccountNumberF) + ', ' + 
			LOWER(t.VendorAccount) + ', ' + 
			LOWER(t.VendorAccountNumberF) + ', ' + 
			LOWER(t.Currency) + ', ' + 
			FORMAT(t.ExchangeRate, N'0.####') + ', ' + 
			FORMAT(t.ExchangeRateLL, N'0.####') + ', ' + 
			FORMAT(t.ExchangeRateEuro, N'0.####') + ', ' + 
			FORMAT(t.TaxExchangeRateLL, N'0.####') + ', ' + 
			FORMAT(t.TaxExchangeRateEuro, N'0.####') + ', ' + 
			LOWER(t.BalanceF) + ', ' + 
			LOWER(t.TaxRateF) + ', ' + 
			LOWER(t.TaxValueF) + ', ' + 
			LOWER(t.NetIsF) + ', ' + 
			LOWER(t.NetIsAR) + ', ' + 
			LOWER(t.NetIsEN) + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Cars.t_CarExpense AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;










GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Cars].[f_CarRentalHistorySearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.Account) + ', ' + 
			LOWER(t.AccountNumberF) + ', ' + 
			LOWER(t.Car) + ', ' + 
			FORMAT(t.AgreementDate, N'dd-MM-yyyy') + ', ' + 
			FORMAT(t.FromDate, N'dd-MM-yyyy') + ', ' + 
			FORMAT(t.ToDate, N'dd-MM-yyyy') + ', ' + 
			LOWER(t.Currency) + ', ' +  
			LOWER(t.DayPriceF) + ', ' +  
			LOWER(t.DayTotalPriceF) + ', ' +  
			LOWER(t.WeekPriceF) + ', ' +  
			LOWER(t.WeekTotalPriceF) + ', ' +  
			LOWER(t.MonthPriceF) + ', ' +  
			LOWER(t.MonthTotalPriceF) + ', ' +  
			LOWER(t.SubtotalF) + ', ' +  
			LOWER(t.DiscountF) + ', ' +  
			LOWER(t.TotalF) + ', ' +  
			LOWER(t.FirstPaymentF) + ', ' +  
			LOWER(t.PaidUpF) + ', ' +  
			LOWER(t.RestF) + ', ' +  
			LOWER(t.DailyTaxF) + ', ' +  
			LOWER(t.TotalTaxF) + ', ' +  
			LOWER(t.ProfitF) + ', ' +  
			FORMAT(t.CheckOutDate, N'dd-MM-yyyy hh:mm tt') + ', ' + 
			FORMAT(t.CheckInDate, N'dd-MM-yyyy hh:mm tt') + ', ' + 
			LOWER(t.DescriptionIs) + ', ' +  
			LOWER(t.Notes) + ', ' +  
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Cars.t_CarRentalHistory AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;












GO

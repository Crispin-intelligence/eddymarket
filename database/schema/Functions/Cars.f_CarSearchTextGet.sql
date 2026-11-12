SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Cars].[f_CarSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.VehicleIdentificationNumber) + ', ' + 
			LOWER(t.StockNumber) + ', ' + 
			LOWER(t.RegistrationNumber) + ', ' + 
			LOWER(t.Make) + ', ' + 
			LOWER(t.Model) + ', ' + 
			FORMAT(t.YearIs, N'yyyy') + ', ' +  ', ' + 
			LOWER(t.Color) + ', ' +
			LOWER(t.ClassName) + ', ' + 
			FORMAT(t.MaximunWeight, N'0') + ', ' + 
			LOWER(t.Engine) + ', ' +
			FORMAT(t.PurchaseDate, N'dd-MM-yyyy') + ', ' + 
			LOWER(t.Currency) + ', ' + 
			LOWER(t.PurchasePriceF) + ', ' +
			LOWER(t.SalePriceF) + ', ' + 
			LOWER(t.DayPriceF) + ', ' + 
			LOWER(t.WeekPriceF) + ', ' + 
			LOWER(t.MonthPriceF) + ', ' + 
			LOWER(t.MonthPriceF) + ', ' + 
			LOWER(t.InsuranceCompany) + ', ' + 
			LOWER(t.InsuranceType) + ', ' + 
			FORMAT(t.InsuranceDate, N'dd-MM-yyyy') + ', ' + 
			FORMAT(t.InsuranceActiveTo, N'dd-MM-yyyy') + ', ' + 
			LOWER(t.DescriptionIs) + ', ' +
			LOWER(t.Notes) + ', ' +
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Cars.t_Car AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;










GO

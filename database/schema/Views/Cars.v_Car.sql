SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Cars].[v_Car]
AS
SELECT  t.ID ,
        t.FullName ,
        t.VehicleIdentificationNumber ,
        t.StockNumber ,
        t.RegistrationNumber ,
        t.MakeID ,
        t.Make ,
        t.ModelID ,
        t.Model ,
        t.YearIs ,
        t.Color ,
        t.ClassID ,
        t.ClassName ,
        t.MaximunWeight ,
        t.Transmission ,
        t.Engine ,
        t.FuelType ,
        t.Odometer ,
        t.AvailabilityIs ,
        t.ImageIs ,
        t.ImagePath ,
        t.DamagesImage ,
        t.DamagesImagePath ,
        t.PurchaseDate ,
        t.CurrencyID ,
        t.Currency ,
        t.PurchasePrice ,
        t.PurchasePriceF ,
        t.PurchasePriceD ,
        t.PurchasePriceLL ,
        t.PurchasePriceEuro ,
        t.SalePrice ,
        t.SalePriceF ,
        t.SalePriceD ,
        t.SalePriceLL ,
        t.SalePriceEuro ,
        t.DayPrice ,
        t.DayPriceF ,
        t.DayPriceD ,
        t.DayPriceLL ,
        t.DayPriceEuro ,
        t.WeekPrice ,
        t.WeekPriceF ,
        t.WeekPriceD ,
        t.WeekPriceLL ,
        t.WeekPriceEuro ,
        t.MonthPrice ,
        t.MonthPriceF ,
        t.MonthPriceD ,
        t.MonthPriceLL ,
        t.MonthPriceEuro ,
        t.OfficeRatio ,
        t.CarFor ,
        t.InsuranceIsActive ,
        t.InsuranceCompany ,
        t.InsuranceType ,
        t.InsuranceDate ,
        t.InsuranceActiveTo ,
        t.DescriptionIs ,
        t.Notes ,
        t.StatusIs ,
        t.SearchText ,
        t.DateCreate ,
        t.CarOwnersCount ,
        t.CarOwners ,
        t.CarRentalCount ,
        t.TotalCarRentsD ,
        t.TotalCarRentsLL ,
        t.TotalCarRentsEuro ,
        t.ProfitCarRentsD ,
        t.ProfitCarRentsLL ,
        t.ProfitCarRentsEuro ,
        t.ExpensesCount ,
        t.TotalExpensesD ,
        t.TotalExpensesLL ,
        t.TotalExpensesEuro ,
        t.ProfitD ,
        t.ProfitLL ,
        t.ProfitEuro ,
        t.IsSync ,
        t.IsSyncImage ,
        t.IsSyncDamagesImage
FROM    Cars.t_Car AS t;









GO

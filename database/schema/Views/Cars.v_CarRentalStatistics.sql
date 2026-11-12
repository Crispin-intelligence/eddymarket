SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Cars].[v_CarRentalStatistics]
AS
SELECT  t.ID ,
        t.Cars ,
        t.CarsTransmissionUnknown ,
        t.CarsTransmissionManual ,
        t.CarsTransmissionAutomatic ,
        t.CarsTransmissionContinuouslyVariable ,
        t.CarsTransmissionSemiAutomatic ,
        t.CarsTransmissionDualClutch ,
        t.CarsFuelTypeUnknown ,
        t.CarsFuelTypeGasoline ,
        t.CarsFuelTypeDiesel ,
        t.CarsFuelTypeGas ,
        t.CarsFuelTypeElectric ,
        t.CarsFuelTypeHybrid ,
        t.CarsFuelTypePetrol ,
        t.CarsFuelTypePetrolGas ,
        t.CarsAvailabilityAvailable ,
        t.CarsAvailabilityUnavailable ,
        t.CarsTotalPurchasePriceD ,
        t.CarsTotalPurchasePriceLL ,
        t.CarsTotalPurchasePriceEuro ,
        t.CarsTotalSalePriceD ,
        t.CarsTotalSalePriceLL ,
        t.CarsTotalSalePriceEuro ,
        t.CarsCarForRent ,
        t.CarsCarForSale ,
        t.CarsCarForExchange ,
        t.CarsInsuranceIsActiveTrue ,
        t.CarsInsuranceIsActiveFalse ,
        t.CarsStatusIsActive ,
        t.CarsStatusIsInactive ,
        t.CarsStatusIsBlocked ,
        t.Classes ,
        t.Owners ,
        t.Expenses ,
        t.ExpensesSubTotalD ,
        t.ExpensesSubTotalLL ,
        t.ExpensesSubTotalEuro ,
        t.ExpensesTaxValueD ,
        t.ExpensesTaxValueLL ,
        t.ExpensesTaxValueEuro ,
        t.ExpensesTotalD ,
        t.ExpensesTotalLL ,
        t.ExpensesTotalEuro ,
        t.Drivers ,
        t.DriversGenderMale ,
        t.DriversGenderFemale ,
        t.DriversGenderUnknown ,
        t.DriversBloodTypeUnknown ,
        t.DriversBloodTypeA_Plus ,
        t.DriversBloodTypeA_Minus ,
        t.DriversBloodTypeB_Plus ,
        t.DriversBloodTypeB_Minus ,
        t.DriversBloodTypeO_Plus ,
        t.DriversBloodTypeO_Minus ,
        t.DriversBloodTypeAB_Plus ,
        t.DriversBloodTypeAB_Minus ,
        t.Makers ,
        t.Models ,
        t.Rentals ,
        t.RentalsSubtotalD ,
        t.RentalsSubtotalLL ,
        t.RentalsSubtotalEuro ,
        t.RentalsDiscountD ,
        t.RentalsDiscountLL ,
        t.RentalsDiscountEuro ,
        t.RentalsTotalD ,
        t.RentalsTotalLL ,
        t.RentalsTotalEuro ,
        t.RentalsTotalTaxD ,
        t.RentalsTotalTaxLL ,
        t.RentalsTotalTaxEuro ,
        t.RentalsProfitD ,
        t.RentalsProfitLL ,
        t.RentalsProfitEuro ,
        t.ProfitD ,
        t.ProfitLL ,
        t.ProfitEuro ,
        t.IsSync
FROM    Cars.t_CarRentalStatistics AS t;







GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarRentalStatisticsRebuildingStatistics]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    BEGIN --Rebuild statistics

      SET @Return = 0;

      UPDATE  Cars.t_CarRentalStatistics
      SET     
	  Cars = (SELECT COUNT(*) FROM Cars.t_Car),
	  CarsTransmissionUnknown = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.Transmission = 0),
	  CarsTransmissionManual = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.Transmission = 1),
	  CarsTransmissionAutomatic = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.Transmission = 2),
	  CarsTransmissionContinuouslyVariable = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.Transmission = 3),
	  CarsTransmissionSemiAutomatic = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.Transmission = 4),
	  CarsTransmissionDualClutch = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.Transmission = 5),
	  CarsFuelTypeUnknown = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.FuelType = 0),
	  CarsFuelTypeGasoline = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.FuelType = 1),
	  CarsFuelTypeDiesel = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.FuelType = 2),
	  CarsFuelTypeGas = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.FuelType = 3),
	  CarsFuelTypeElectric = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.FuelType = 4),
	  CarsFuelTypeHybrid = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.FuelType = 5),
	  CarsFuelTypePetrol = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.FuelType = 6),
	  CarsFuelTypePetrolGas = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.FuelType = 7),
	  CarsAvailabilityAvailable = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.AvailabilityIs = 0),
	  CarsAvailabilityUnavailable = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.AvailabilityIs = 1),
	  CarsTotalPurchasePriceD = (SELECT ISNULL(SUM(s.PurchasePriceD),0) FROM Cars.t_Car AS s),
	  CarsTotalPurchasePriceLL = (SELECT ISNULL(SUM(s.PurchasePriceLL),0) FROM Cars.t_Car AS s),
	  CarsTotalPurchasePriceEuro = (SELECT ISNULL(SUM(s.PurchasePriceEuro),0) FROM Cars.t_Car AS s),
	  CarsTotalSalePriceD = (SELECT ISNULL(SUM(s.SalePriceD),0) FROM Cars.t_Car AS s),
	  CarsTotalSalePriceLL = (SELECT ISNULL(SUM(s.SalePriceLL),0) FROM Cars.t_Car AS s),
	  CarsTotalSalePriceEuro = (SELECT ISNULL(SUM(s.SalePriceEuro),0) FROM Cars.t_Car AS s),
	  CarsCarForRent = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.CarFor = 0),
	  CarsCarForSale = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.CarFor = 1),
	  CarsCarForExchange = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.CarFor = 2),
	  CarsInsuranceIsActiveTrue = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.InsuranceIsActive = 1),
	  CarsInsuranceIsActiveFalse = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.InsuranceIsActive = 0),
	  CarsStatusIsActive = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.StatusIs = 0),
	  CarsStatusIsInactive = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.StatusIs = 1),
	  CarsStatusIsBlocked = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.StatusIs = 2),
	  Classes = (SELECT COUNT(*) FROM Cars.t_CarClass),
	  Owners = (SELECT COUNT(*) FROM Cars.t_CarOwnersProfile),
	  Expenses = (SELECT COUNT(*) FROM Cars.t_CarExpense),
	  ExpensesSubTotalD = (SELECT ISNULL(SUM(s.BalanceD),0) FROM Cars.t_CarExpense AS s),
	  ExpensesSubTotalLL = (SELECT ISNULL(SUM(s.BalanceLL),0) FROM Cars.t_CarExpense AS s),
	  ExpensesSubTotalEuro = (SELECT ISNULL(SUM(s.BalanceEuro),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTaxValueD = (SELECT ISNULL(SUM(s.TaxValueD),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTaxValueLL = (SELECT ISNULL(SUM(s.TaxValueLL),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTaxValueEuro = (SELECT ISNULL(SUM(s.TaxValueEuro),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTotalD = (SELECT ISNULL(SUM(s.NetIsD),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTotalLL = (SELECT ISNULL(SUM(s.NetIsLL),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTotalEuro = (SELECT ISNULL(SUM(s.NetIsEuro),0) FROM Cars.t_CarExpense AS s),
	  Drivers = (SELECT COUNT(*) FROM Cars.t_CarDriver),
	  DriversGenderMale = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.Gender = 0),
	  DriversGenderFemale = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.Gender = 1),
	  DriversGenderUnknown = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.Gender = 2),
	  DriversBloodTypeUnknown = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 0),
	  DriversBloodTypeA_Plus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 1),
	  DriversBloodTypeA_Minus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 2),
	  DriversBloodTypeB_Plus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 3),
	  DriversBloodTypeB_Minus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 4),
	  DriversBloodTypeO_Plus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 5),
	  DriversBloodTypeO_Minus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 6),
	  DriversBloodTypeAB_Plus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 7),
	  DriversBloodTypeAB_Minus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 8),
	  Makers = (SELECT COUNT(*) FROM Cars.t_CarMake),
	  Models = (SELECT COUNT(*) FROM Cars.t_CarModel),
	  Rentals = (SELECT COUNT(*) FROM Cars.t_CarRental) + (SELECT COUNT(*) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsSubtotalD = (SELECT ISNULL(SUM(s.SubtotalD),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.SubtotalD),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsSubtotalLL = (SELECT ISNULL(SUM(s.SubtotalLL),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.SubtotalLL),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsSubtotalEuro = (SELECT ISNULL(SUM(s.SubtotalEuro),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.SubtotalEuro),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsDiscountD = (SELECT ISNULL(SUM(s.DiscountD),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.DiscountD),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsDiscountLL = (SELECT ISNULL(SUM(s.DiscountLL),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.DiscountLL),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsDiscountEuro = (SELECT ISNULL(SUM(s.DiscountEuro),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.DiscountEuro),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsTotalD = (SELECT ISNULL(SUM(s.TotalD),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.TotalD),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsTotalLL = (SELECT ISNULL(SUM(s.TotalLL),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.TotalLL),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsTotalEuro = (SELECT ISNULL(SUM(s.TotalEuro),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.TotalEuro),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsTotalTaxD = (SELECT ISNULL(SUM(s.TotalTaxD),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.TotalTaxD),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsTotalTaxLL = (SELECT ISNULL(SUM(s.TotalTaxLL),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.TotalTaxLL),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsTotalTaxEuro = (SELECT ISNULL(SUM(s.TotalTaxEuro),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.TotalTaxEuro),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsProfitD = (SELECT ISNULL(SUM(s.ProfitD),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.ProfitD),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsProfitLL = (SELECT ISNULL(SUM(s.ProfitLL),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.ProfitLL),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3),
	  RentalsProfitEuro = (SELECT ISNULL(SUM(s.ProfitEuro),0) FROM Cars.t_CarRental AS s) + (SELECT ISNULL(SUM(s.ProfitEuro),0) FROM Cars.t_CarRentalHistory AS s WHERE s.StatusIs <> 3);
  
      UPDATE  Cars.t_CarRentalStatistics
      SET     ProfitD = RentalsProfitD - ExpensesTotalD ,
              ProfitLL = RentalsProfitLL - ExpensesTotalLL ,
              ProfitEuro = RentalsProfitEuro - ExpensesTotalEuro;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarRentalStatisticsMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                '00000000-0000-0000-0000-000000000000' ,
                @Event ,
                6 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;



GO

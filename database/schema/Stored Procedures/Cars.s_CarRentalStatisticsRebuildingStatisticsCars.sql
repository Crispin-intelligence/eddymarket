SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarRentalStatisticsRebuildingStatisticsCars]
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
	  CarsStatusIsBlocked = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.StatusIs = 2);

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

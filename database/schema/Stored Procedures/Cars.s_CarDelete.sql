SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarDelete]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @MakeID_Old UNIQUEIDENTIFIER ,
        @ModelID_Old UNIQUEIDENTIFIER ,
        @ClassID_Old UNIQUEIDENTIFIER ,
        @Transmission_Old TINYINT ,
        @FuelType_Old TINYINT ,
        @AvailabilityIs_Old TINYINT ,
        @PurchasePriceD_Old FLOAT ,
        @PurchasePriceLL_Old FLOAT ,
        @PurchasePriceEuro_Old FLOAT ,
        @SalePriceD_Old FLOAT ,
        @SalePriceLL_Old FLOAT ,
        @SalePriceEuro_Old FLOAT ,
        @CarFor_Old TINYINT ,
        @InsuranceIsActive_Old BIT ,
        @StatusIs_Old TINYINT ,
        @Return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @MakeID_Old = s.MakeID ,
              @ModelID_Old = s.ModelID ,
              @ClassID_Old = s.ClassID ,
              @Transmission_Old = s.Transmission ,
              @FuelType_Old = s.FuelType ,
              @AvailabilityIs_Old = s.AvailabilityIs ,
              @PurchasePriceD_Old = s.PurchasePriceD ,
              @PurchasePriceLL_Old = s.PurchasePriceLL ,
              @PurchasePriceEuro_Old = s.PurchasePriceEuro ,
              @SalePriceD_Old = s.SalePriceD ,
              @SalePriceLL_Old = s.SalePriceLL ,
              @SalePriceEuro_Old = s.SalePriceEuro ,
              @CarFor_Old = s.CarFor ,
              @InsuranceIsActive_Old = s.InsuranceIsActive ,
              @StatusIs_Old = s.StatusIs
      FROM    Cars.t_Car AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Delete

      SET @Return = 0;

      DELETE  FROM Cars.t_CarOwners
      WHERE   CarID = @ID;

      DELETE  FROM Cars.t_Car
      WHERE   ID = @ID;

    END;
   
    BEGIN --Fix

      UPDATE  Cars.t_CarMake
      SET     CarsCount -= 1
      WHERE   ID = @MakeID_Old;

      UPDATE  Cars.t_CarModel
      SET     CarsCount -= 1
      WHERE   ID = @ModelID_Old;

      UPDATE  Cars.t_CarClass
      SET     CarsCount -= 1
      WHERE   ID = @ClassID_Old;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @ID ,
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    BEGIN --Update t_CarRentalStatistics

      UPDATE  Cars.t_CarRentalStatistics
      SET     Cars -= 1 ,
              CarsTransmissionUnknown -= IIF(@Transmission_Old = 0, 1, 0) ,
              CarsTransmissionManual -= IIF(@Transmission_Old = 1, 1, 0) ,
              CarsTransmissionAutomatic -= IIF(@Transmission_Old = 2, 1, 0) ,
              CarsTransmissionContinuouslyVariable -= IIF(@Transmission_Old = 3, 1, 0) ,
              CarsTransmissionSemiAutomatic -= IIF(@Transmission_Old = 4, 1, 0) ,
              CarsTransmissionDualClutch -= IIF(@Transmission_Old = 5, 1, 0) ,
              CarsFuelTypeUnknown -= IIF(@FuelType_Old = 0, 1, 0) ,
              CarsFuelTypeGasoline -= IIF(@FuelType_Old = 1, 1, 0) ,
              CarsFuelTypeDiesel -= IIF(@FuelType_Old = 2, 1, 0) ,
              CarsFuelTypeGas -= IIF(@FuelType_Old = 3, 1, 0) ,
              CarsFuelTypeElectric -= IIF(@FuelType_Old = 4, 1, 0) ,
              CarsFuelTypeHybrid -= IIF(@FuelType_Old = 5, 1, 0) ,
              CarsFuelTypePetrol -= IIF(@FuelType_Old = 6, 1, 0) ,
              CarsFuelTypePetrolGas -= IIF(@FuelType_Old = 7, 1, 0) ,
              CarsAvailabilityAvailable -= IIF(@AvailabilityIs_Old = 0, 1, 0) ,
              CarsAvailabilityUnavailable -= IIF(@AvailabilityIs_Old = 1, 1, 0) ,
              CarsTotalPurchasePriceD -= @PurchasePriceD_Old ,
              CarsTotalPurchasePriceLL -= @PurchasePriceLL_Old ,
              CarsTotalPurchasePriceEuro -= @PurchasePriceEuro_Old ,
              CarsTotalSalePriceD -= @SalePriceD_Old ,
              CarsTotalSalePriceLL -= @SalePriceLL_Old ,
              CarsTotalSalePriceEuro -= @SalePriceEuro_Old ,
              CarsCarForRent -= IIF(@CarFor_Old = 0, 1, 0) ,
              CarsCarForSale -= IIF(@CarFor_Old = 1, 1, 0) ,
              CarsCarForExchange -= IIF(@CarFor_Old = 1, 1, 0) ,
              CarsInsuranceIsActiveTrue -= IIF(@InsuranceIsActive_Old = 1, 1, 0) ,
              CarsInsuranceIsActiveFalse -= IIF(@InsuranceIsActive_Old = 0, 1, 0) ,
              CarsStatusIsActive -= IIF(@StatusIs_Old = 0, 1, 0) ,
              CarsStatusIsInactive -= IIF(@StatusIs_Old = 1, 1, 0) ,
              CarsStatusIsBlocked -= IIF(@StatusIs_Old = 2, 1, 0);

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

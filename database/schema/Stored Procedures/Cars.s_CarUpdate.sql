SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Cars].[s_CarUpdate]
  @VehicleIdentificationNumber NVARCHAR(450) ,
  @StockNumber NVARCHAR(MAX) ,
  @RegistrationNumber NVARCHAR(MAX) ,
  @MakeID UNIQUEIDENTIFIER ,
  @ModelID UNIQUEIDENTIFIER ,
  @YearIs DATE ,
  @Color NVARCHAR(MAX) ,
  @ClassID UNIQUEIDENTIFIER ,
  @MaximunWeight INT ,
  @Transmission TINYINT ,
  @Engine NVARCHAR(MAX) ,
  @FuelType TINYINT ,
  @Odometer INT ,
  @ImageIs IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
  @DamagesImage IMAGE ,
  @DamagesImagePath NVARCHAR(MAX) ,
  @PurchaseDate DATE ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @PurchasePrice FLOAT ,
  @SalePrice FLOAT ,
  @DayPrice FLOAT ,
  @WeekPrice FLOAT ,
  @MonthPrice FLOAT ,
  @OfficeRatio DECIMAL(5, 2) ,
  @CarFor TINYINT ,
  @InsuranceCompany NVARCHAR(MAX) ,
  @InsuranceType NVARCHAR(MAX) ,
  @InsuranceDate DATE ,
  @InsuranceActiveTo DATE ,
  @DescriptionIs NVARCHAR(MAX) ,
  @Notes NVARCHAR(MAX) ,
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

      DECLARE @FullName NVARCHAR(MAX) = @RegistrationNumber + IIF(@Color = '', '', ', ' + @Color) ,
        @FullNameOld NVARCHAR(450) ,
        @Transmission_Old TINYINT ,
        @FuelType_Old TINYINT ,
        @PurchasePriceD_Old FLOAT ,
        @PurchasePriceLL_Old FLOAT ,
        @PurchasePriceEuro_Old FLOAT ,
        @SalePriceD_Old FLOAT ,
        @SalePriceLL_Old FLOAT ,
        @SalePriceEuro_Old FLOAT ,
        @CarFor_Old TINYINT ,
        @InsuranceIsActive_Old BIT ,
        @StatusIs_Old TINYINT ,
        @ExchangeRate DECIMAL(18, 2) ,
        @ExchangeRateLL DECIMAL(18, 2) ,
        @ExchangeRateEuro DECIMAL(18, 2) ,
        @PurchasePriceD FLOAT ,
        @SalePriceD FLOAT ,
        @DayPriceD FLOAT ,
        @WeekPriceD FLOAT ,
        @MonthPriceD FLOAT ,
        @InsuranceIsActive BIT ,
        @Return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @FullNameOld = s.FullName ,
              @Transmission_Old = s.Transmission ,
              @FuelType_Old = s.FuelType ,
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

      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);
      SET @ExchangeRateLL = [Currencys].[f_CurrencyGetExchangeRateLL]();
      SET @ExchangeRateEuro = [Currencys].[f_CurrencyGetExchangeRateEuro]();
	  
      SET @PurchasePriceD = @PurchasePrice / @ExchangeRate;
      SET @SalePriceD = @SalePrice / @ExchangeRate;
      SET @DayPriceD = @DayPrice / @ExchangeRate;
      SET @WeekPriceD = @WeekPrice / @ExchangeRate;
      SET @MonthPriceD = @MonthPrice / @ExchangeRate;

      SET @InsuranceIsActive = IIF(@InsuranceActiveTo >= CONVERT(DATE, GETDATE()), 1, 0);

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Cars.t_Car
      SET     ID = @ID ,
              FullName = @FullName ,
              VehicleIdentificationNumber = @VehicleIdentificationNumber ,
              StockNumber = @StockNumber ,
              RegistrationNumber = @RegistrationNumber ,
              MakeID = @MakeID ,
              Make = Cars.f_CarMakeGetName(@MakeID) ,
              ModelID = @ModelID ,
              Model = Cars.f_CarModelGetName(@ModelID) ,
              YearIs = @YearIs ,
              Color = @Color ,
              ClassID = @ClassID ,
              ClassName = Cars.f_CarClassGetName(@ClassID) ,
              MaximunWeight = @MaximunWeight ,
              Transmission = @Transmission ,
              Engine = @Engine ,
              FuelType = @FuelType ,
              Odometer = @Odometer ,
              ImageIs = @ImageIs ,
              ImagePath = @ImagePath ,
              DamagesImage = @DamagesImage ,
              DamagesImagePath = @DamagesImagePath ,
              PurchaseDate = @PurchaseDate ,
              CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              PurchasePrice = @PurchasePrice ,
              PurchasePriceF = Currencys.f_Format(@CurrencyID, @PurchasePrice) ,
              PurchasePriceD = @PurchasePriceD ,
              PurchasePriceLL = Currencys.f_ExchangeToLL(@CurrencyID, @PurchasePrice, @PurchasePriceD) ,
              PurchasePriceEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @PurchasePrice, @PurchasePriceD) ,
              SalePrice = @SalePrice ,
              SalePriceF = Currencys.f_Format(@CurrencyID, @SalePrice) ,
              SalePriceD = @SalePriceD ,
              SalePriceLL = Currencys.f_ExchangeToLL(@CurrencyID, @SalePrice, @SalePriceD) ,
              SalePriceEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @SalePrice, @SalePriceD) ,
              DayPrice = @DayPrice ,
              DayPriceF = Currencys.f_Format(@CurrencyID, @DayPrice) ,
              DayPriceD = @DayPriceD ,
              DayPriceLL = Currencys.f_ExchangeToLL(@CurrencyID, @DayPrice, @DayPriceD) ,
              DayPriceEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @DayPrice, @DayPriceD) ,
              WeekPrice = @WeekPrice ,
              WeekPriceF = Currencys.f_Format(@CurrencyID, @WeekPrice) ,
              WeekPriceD = @WeekPriceD ,
              WeekPriceLL = Currencys.f_ExchangeToLL(@CurrencyID, @WeekPrice, @WeekPriceD) ,
              WeekPriceEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @WeekPrice, @WeekPriceD) ,
              MonthPrice = @MonthPrice ,
              MonthPriceF = Currencys.f_Format(@CurrencyID, @MonthPrice) ,
              MonthPriceD = @MonthPriceD ,
              MonthPriceLL = Currencys.f_ExchangeToLL(@CurrencyID, @MonthPrice, @MonthPriceD) ,
              MonthPriceEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @MonthPrice, @MonthPriceD) ,
              OfficeRatio = @OfficeRatio ,
              CarFor = @CarFor ,
              InsuranceIsActive = @InsuranceIsActive ,
              InsuranceCompany = @InsuranceCompany ,
              InsuranceType = @InsuranceType ,
              InsuranceDate = @InsuranceDate ,
              InsuranceActiveTo = @InsuranceActiveTo ,
              DescriptionIs = @DescriptionIs ,
              Notes = @Notes ,
              StatusIs = 0 ,
              IsSyncImage = IIF(@ImagePath = '', 0, 1) ,
              IsSyncDamagesImage = IIF(@DamagesImagePath = '', 0, 1)
      WHERE   ID = @ID;
                
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

    IF @FullNameOld COLLATE Arabic_CS_AS <> @FullName COLLATE Arabic_CS_AS
    BEGIN --Fix

      UPDATE  Cars.t_CarOwners
      SET     Car = @FullName
      WHERE   CarID = @ID;

      UPDATE  Cars.t_CarExpense
      SET     Car = @FullName
      WHERE   CarID = @ID;
  
      UPDATE  Cars.t_CarRental
      SET     Car = @FullName
      WHERE   CarID = @ID;

      UPDATE  Cars.t_CarRentalHistory
      SET     Car = @FullName
      WHERE   CarID = @ID;
  
    END;

    BEGIN --Update t_CarRentalStatistics

      UPDATE  Cars.t_CarRentalStatistics
      SET     CarsTransmissionUnknown -= IIF(@Transmission_Old = 0, 1, 0) ,
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

      UPDATE  Cars.t_CarRentalStatistics
      SET     CarsTransmissionUnknown += IIF(@Transmission = 0, 1, 0) ,
              CarsTransmissionManual += IIF(@Transmission = 1, 1, 0) ,
              CarsTransmissionAutomatic += IIF(@Transmission = 2, 1, 0) ,
              CarsTransmissionContinuouslyVariable += IIF(@Transmission = 3, 1, 0) ,
              CarsTransmissionSemiAutomatic += IIF(@Transmission = 4, 1, 0) ,
              CarsTransmissionDualClutch += IIF(@Transmission = 5, 1, 0) ,
              CarsFuelTypeUnknown += IIF(@FuelType = 0, 1, 0) ,
              CarsFuelTypeGasoline += IIF(@FuelType = 1, 1, 0) ,
              CarsFuelTypeDiesel += IIF(@FuelType = 2, 1, 0) ,
              CarsFuelTypeGas += IIF(@FuelType = 3, 1, 0) ,
              CarsFuelTypeElectric += IIF(@FuelType = 4, 1, 0) ,
              CarsFuelTypeHybrid += IIF(@FuelType = 5, 1, 0) ,
              CarsFuelTypePetrol += IIF(@FuelType = 6, 1, 0) ,
              CarsFuelTypePetrolGas += IIF(@FuelType = 7, 1, 0) ,
              CarsTotalPurchasePriceD += @PurchasePriceD ,
              CarsTotalPurchasePriceLL += Currencys.f_ExchangeToLL(@CurrencyID, @PurchasePrice, @PurchasePriceD) ,
              CarsTotalPurchasePriceEuro += Currencys.f_ExchangeToEuro(@CurrencyID, @PurchasePrice, @PurchasePriceD) ,
              CarsTotalSalePriceD += @SalePriceD ,
              CarsTotalSalePriceLL += Currencys.f_ExchangeToLL(@CurrencyID, @SalePrice, @SalePriceD) ,
              CarsTotalSalePriceEuro += Currencys.f_ExchangeToEuro(@CurrencyID, @SalePrice, @SalePriceD) ,
              CarsCarForRent += IIF(@CarFor = 0, 1, 0) ,
              CarsCarForSale += IIF(@CarFor = 1, 1, 0) ,
              CarsCarForExchange += IIF(@CarFor = 1, 1, 0) ,
              CarsInsuranceIsActiveTrue += IIF(@InsuranceIsActive = 1, 1, 0) ,
              CarsInsuranceIsActiveFalse += IIF(@InsuranceIsActive = 0, 1, 0) ,
              CarsStatusIsActive += 1;

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

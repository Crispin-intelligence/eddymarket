SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarInsert]
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
  @CarOwnersTable [Cars].[tt_CarOwners] READONLY ,
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
        @ExchangeRate DECIMAL(18, 2) ,
        @ExchangeRateLL DECIMAL(18, 2) ,
        @ExchangeRateEuro DECIMAL(18, 2) ,
        @PurchasePriceD FLOAT ,
        @SalePriceD FLOAT ,
        @DayPriceD FLOAT ,
        @WeekPriceD FLOAT ,
        @MonthPriceD FLOAT ,
        @InsuranceIsActive BIT ,
        @CarOwnersCount INT ,
        @CarOwners NVARCHAR(MAX) ,
        @Return INT;

    END;

    BEGIN --Set info
	    
      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);
      SET @ExchangeRateLL = [Currencys].[f_CurrencyGetExchangeRateLL]();
      SET @ExchangeRateEuro = [Currencys].[f_CurrencyGetExchangeRateEuro]();
	  
      SET @PurchasePriceD = @PurchasePrice / @ExchangeRate;
      SET @SalePriceD = @SalePrice / @ExchangeRate;
      SET @DayPriceD = @DayPrice / @ExchangeRate;
      SET @WeekPriceD = @WeekPrice / @ExchangeRate;
      SET @MonthPriceD = @MonthPrice / @ExchangeRate;

      SET @InsuranceIsActive = IIF(@InsuranceActiveTo >= CONVERT(DATE, GETDATE()), 1, 0);

      SELECT  @CarOwnersCount = COUNT(s.ID)
      FROM    @CarOwnersTable AS s;
                               
      SET @CarOwners = Alls.f_FixXML(( SELECT DISTINCT
                                              ', ' + s1.Name AS [text()]
                                       FROM   @CarOwnersTable AS s
                                       INNER JOIN Cars.t_CarOwnersProfile AS s1 ON s1.ID = s.OwnerProfileID
                                     FOR
                                       XML PATH('')
                                     ));

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Cars.t_Car
              ( ID ,
                FullName ,
                VehicleIdentificationNumber ,
                StockNumber ,
                RegistrationNumber ,
                MakeID ,
                Make ,
                ModelID ,
                Model ,
                YearIs ,
                Color ,
                ClassID ,
                ClassName ,
                MaximunWeight ,
                Transmission ,
                Engine ,
                FuelType ,
                Odometer ,
                ImageIs ,
                ImagePath ,
                DamagesImage ,
                DamagesImagePath ,
                PurchaseDate ,
                CurrencyID ,
                Currency ,
                PurchasePrice ,
                PurchasePriceF ,
                PurchasePriceD ,
                PurchasePriceLL ,
                PurchasePriceEuro ,
                SalePrice ,
                SalePriceF ,
                SalePriceD ,
                SalePriceLL ,
                SalePriceEuro ,
                DayPrice ,
                DayPriceF ,
                DayPriceD ,
                DayPriceLL ,
                DayPriceEuro ,
                WeekPrice ,
                WeekPriceF ,
                WeekPriceD ,
                WeekPriceLL ,
                WeekPriceEuro ,
                MonthPrice ,
                MonthPriceF ,
                MonthPriceD ,
                MonthPriceLL ,
                MonthPriceEuro ,
                OfficeRatio ,
                CarFor ,
                InsuranceIsActive ,
                InsuranceCompany ,
                InsuranceType ,
                InsuranceDate ,
                InsuranceActiveTo ,
                DescriptionIs ,
                Notes ,
                CarOwnersCount ,
                CarOwners ,
                IsSyncImage ,
                IsSyncDamagesImage
              )
      VALUES  ( @ID ,
                @FullName ,
                @VehicleIdentificationNumber ,
                @StockNumber ,
                @RegistrationNumber ,
                @MakeID ,
                Cars.f_CarMakeGetName(@MakeID) ,
                @ModelID ,
                Cars.f_CarModelGetName(@ModelID) ,
                @YearIs ,
                @Color ,
                @ClassID ,
                Cars.f_CarClassGetName(@ClassID) ,
                @MaximunWeight ,
                @Transmission ,
                @Engine ,
                @FuelType ,
                @Odometer ,
                @ImageIs ,
                @ImagePath ,
                @DamagesImage ,
                @DamagesImagePath ,
                @PurchaseDate ,
                @CurrencyID ,
                Currencys.f_CurrencyGetName(@CurrencyID) ,
                @PurchasePrice ,
                Currencys.f_Format(@CurrencyID, @PurchasePrice) ,
                @PurchasePriceD ,
                Currencys.f_ExchangeToLL(@CurrencyID, @PurchasePrice, @PurchasePriceD) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @PurchasePrice, @PurchasePriceD) ,
                @SalePrice ,
                Currencys.f_Format(@CurrencyID, @SalePrice) ,
                @SalePriceD ,
                Currencys.f_ExchangeToLL(@CurrencyID, @SalePrice, @SalePriceD) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @SalePrice, @SalePriceD) ,
                @DayPrice ,
                Currencys.f_Format(@CurrencyID, @DayPrice) ,
                @DayPriceD ,
                Currencys.f_ExchangeToLL(@CurrencyID, @DayPrice, @DayPriceD) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @DayPrice, @DayPriceD) ,
                @WeekPrice ,
                Currencys.f_Format(@CurrencyID, @WeekPrice) ,
                @WeekPriceD ,
                Currencys.f_ExchangeToLL(@CurrencyID, @WeekPrice, @WeekPriceD) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @WeekPrice, @WeekPriceD) ,
                @MonthPrice ,
                Currencys.f_Format(@CurrencyID, @MonthPrice) ,
                @MonthPriceD ,
                Currencys.f_ExchangeToLL(@CurrencyID, @MonthPrice, @MonthPriceD) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @MonthPrice, @MonthPriceD) ,
                @OfficeRatio ,
                @CarFor ,
                @InsuranceIsActive ,
                @InsuranceCompany ,
                @InsuranceType ,
                @InsuranceDate ,
                @InsuranceActiveTo ,
                @DescriptionIs ,
                @Notes ,
                @CarOwnersCount ,
                @CarOwners ,
                IIF(@ImagePath = '', 0, 1) ,
                IIF(@DamagesImagePath = '', 0, 1)
              );

    END;

    BEGIN --Insert t_CarOwners

      INSERT  INTO Cars.t_CarOwners
              ( ID ,
                CarID ,
                Car ,
                OwnerProfileID ,
                OwnerProfile ,
                ProfitRatio 
	          )
      SELECT  s.ID ,
              @ID ,
              @VehicleIdentificationNumber ,
              s.OwnerProfileID ,
              Cars.f_CarOwnersProfileGetName(s.OwnerProfileID) ,
              s.ProfitRatio
      FROM    @CarOwnersTable AS s;

    END;

    BEGIN --Fix t_Car, t_CarOwners
    
      UPDATE  Cars.t_Car
      SET     SearchText = ''
      WHERE   ID = @ID;

      UPDATE  Cars.t_CarOwners
      SET     SearchText = ''
      WHERE   CarID = @ID;

      UPDATE  Cars.t_CarOwnersProfile
      SET     CarsCount = ( SELECT  COUNT(s.ID)
                            FROM    Cars.t_CarOwners AS s
                            WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                          )
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @CarOwnersTable AS s
                       WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID );

    END;

    BEGIN --Insert t_CarMoving

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
      SET     Cars += 1 ,
              CarsTransmissionUnknown += IIF(@Transmission = 0, 1, 0) ,
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
              CarsAvailabilityAvailable += 1 ,
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

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  @Return;

  END CATCH;

END;





GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_GymClassUpdatePrice] @CurrencyID UNIQUEIDENTIFIER ,
  @PriceDaily FLOAT ,
  @PriceWeekly FLOAT ,
  @PriceMonthly FLOAT ,
  @UserID UNIQUEIDENTIFIER ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @IDAndEvent Alls.tt_IDAndEvent READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT ,
        @ExchangeRate DECIMAL(18, 2) ,
        @PriceDailyF NVARCHAR(MAX) ,
        @PriceDailyD FLOAT ,
        @PriceWeeklyF NVARCHAR(MAX) ,
        @PriceWeeklyD FLOAT ,
        @PriceMonthlyF NVARCHAR(MAX) ,
        @PriceMonthlyD FLOAT;

    END;

    BEGIN --Set info
	
      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);
     
      SET @PriceDailyD = @PriceDaily / @ExchangeRate;
      SET @PriceDailyF = Currencys.f_Format(@CurrencyID, @PriceDaily);
      SET @PriceWeeklyD = @PriceWeekly / @ExchangeRate;
      SET @PriceWeeklyF = Currencys.f_Format(@CurrencyID, @PriceWeekly);
      SET @PriceMonthlyD = @PriceMonthly / @ExchangeRate;
      SET @PriceMonthlyF = Currencys.f_Format(@CurrencyID, @PriceMonthly);

    END;

    BEGIN --Update 

      SET @Return = 0;

      UPDATE Gym.t_GymClass
        SET CurrencyID = @CurrencyID ,
            Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
            PriceDaily = @PriceDaily ,
            PriceDailyF = @PriceDailyF ,
            PriceDailyD = @PriceDailyD ,
            PriceDailyLL = Currencys.f_ExchangeToLL(@CurrencyID, @PriceDaily, @PriceDailyD) ,
            PriceDailyEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @PriceDaily, @PriceDailyD) ,
            PriceWeekly = @PriceWeekly ,
            PriceWeeklyF = @PriceWeeklyF ,
            PriceWeeklyD = @PriceWeeklyD ,
            PriceWeeklyLL = Currencys.f_ExchangeToLL(@CurrencyID, @PriceWeekly, @PriceWeeklyD) ,
            PriceWeeklyEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @PriceWeekly, @PriceWeeklyD) ,
            PriceMonthly = @PriceMonthly ,
            PriceMonthlyF = @PriceMonthlyF ,
            PriceMonthlyD = @PriceMonthlyD ,
            PriceMonthlyLL = Currencys.f_ExchangeToLL(@CurrencyID, @PriceMonthly, @PriceMonthlyD) ,
            PriceMonthlyEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @PriceMonthly, @PriceMonthlyD)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDAndEvent AS s
                        WHERE s.ID = t_GymClass.ID );
    
      UPDATE Gym.t_GymClass
        SET SalaryDaily = Calculation.Discount(PriceDaily, 100 - SalaryDailyPercent) ,
            SalaryDailyF = Currencys.f_Format(CurrencyID, Calculation.Discount(PriceDaily, 100 - SalaryDailyPercent)) ,
            SalaryDailyD = Calculation.Discount(PriceDailyD, 100 - SalaryDailyPercent) ,
            SalaryDailyLL = Calculation.Discount(PriceDailyLL, 100 - SalaryDailyPercent) ,
            SalaryDailyEuro = Calculation.Discount(PriceDailyEuro, 100 - SalaryDailyPercent) ,
            SalaryWeekly = Calculation.Discount(PriceWeekly, 100 - SalaryWeeklyPercent) ,
            SalaryWeeklyF = Currencys.f_Format(CurrencyID, Calculation.Discount(PriceWeekly, 100 - SalaryWeeklyPercent)) ,
            SalaryWeeklyD = Calculation.Discount(PriceWeeklyD, 100 - SalaryWeeklyPercent) ,
            SalaryWeeklyLL = Calculation.Discount(PriceWeeklyLL, 100 - SalaryWeeklyPercent) ,
            SalaryWeeklyEuro = Calculation.Discount(PriceWeeklyEuro, 100 - SalaryWeeklyPercent) ,
            SalaryMonthly = Calculation.Discount(PriceMonthly, 100 - SalaryMonthlyPercent) ,
            SalaryMonthlyF = Currencys.f_Format(CurrencyID, Calculation.Discount(PriceMonthly, 100 - SalaryMonthlyPercent)) ,
            SalaryMonthlyD = Calculation.Discount(PriceMonthlyD, 100 - SalaryMonthlyPercent) ,
            SalaryMonthlyLL = Calculation.Discount(PriceMonthlyLL, 100 - SalaryMonthlyPercent) ,
            SalaryMonthlyEuro = Calculation.Discount(PriceMonthlyEuro, 100 - SalaryMonthlyPercent)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDAndEvent AS s
                        WHERE s.ID = t_GymClass.ID );

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Gym.t_GymClassMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        SELECT @UserID ,
            s.ID ,
            s.EventIs ,
            1 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          FROM @IDAndEvent AS s;

    END;

    COMMIT TRANSACTION;

    SELECT 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT @Return;

  END CATCH;

END;




GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Gym].[s_GymClassInsert] @Name NVARCHAR(MAX) ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @PriceDaily FLOAT ,
  @PriceWeekly FLOAT ,
  @PriceMonthly FLOAT ,
  @AccountEmployeeID UNIQUEIDENTIFIER ,
  @SalaryDailyPercent DECIMAL(5, 2) ,
  @SalaryDaily FLOAT ,
  @SalaryWeeklyPercent DECIMAL(5, 2) ,
  @SalaryWeekly FLOAT ,
  @SalaryMonthlyPercent DECIMAL(5, 2) ,
  @SalaryMonthly FLOAT ,
  @Day0 BIT ,
  @Day0FromTime TIME(7) ,
  @Day0ToTime TIME(7) ,
  @Day1 BIT ,
  @Day1FromTime TIME(7) ,
  @Day1ToTime TIME(7) ,
  @Day2 BIT ,
  @Day2FromTime TIME(7) ,
  @Day2ToTime TIME(7) ,
  @Day3 BIT ,
  @Day3FromTime TIME(7) ,
  @Day3ToTime TIME(7) ,
  @Day4 BIT ,
  @Day4FromTime TIME(7) ,
  @Day4ToTime TIME(7) ,
  @Day5 BIT ,
  @Day5FromTime TIME(7) ,
  @Day5ToTime TIME(7) ,
  @Day6 BIT ,
  @Day6FromTime TIME(7) ,
  @Day6ToTime TIME(7) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @Return INT ,
        @ExchangeRate DECIMAL(18, 2) ,
        @PriceDailyF NVARCHAR(MAX) ,
        @PriceDailyD FLOAT ,
        @PriceWeeklyF NVARCHAR(MAX) ,
        @PriceWeeklyD FLOAT ,
        @PriceMonthlyF NVARCHAR(MAX) ,
        @PriceMonthlyD FLOAT ,
        @SalaryDailyF NVARCHAR(MAX) ,
        @SalaryDailyD FLOAT ,
        @SalaryWeeklyF NVARCHAR(MAX) ,
        @SalaryWeeklyD FLOAT ,
        @SalaryMonthlyF NVARCHAR(MAX) ,
        @SalaryMonthlyD FLOAT;
					
    END;

    BEGIN --Set info
		
      SET @ExchangeRate = Currencys.f_CurrencyGetExchangeRate(@CurrencyID);

      SET @PriceDailyD = @PriceDaily / @ExchangeRate;
      SET @PriceDailyF = Currencys.f_Format(@CurrencyID, @PriceDaily);
      SET @PriceWeeklyD = @PriceWeekly / @ExchangeRate;
      SET @PriceWeeklyF = Currencys.f_Format(@CurrencyID, @PriceWeekly);
      SET @PriceMonthlyD = @PriceMonthly / @ExchangeRate;
      SET @PriceMonthlyF = Currencys.f_Format(@CurrencyID, @PriceMonthly);

      SET @SalaryDailyD = @SalaryDaily / @ExchangeRate;
      SET @SalaryDailyF = Currencys.f_Format(@CurrencyID, @SalaryDaily);
      SET @SalaryWeeklyD = @SalaryWeekly / @ExchangeRate;
      SET @SalaryWeeklyF = Currencys.f_Format(@CurrencyID, @SalaryWeekly);
      SET @SalaryMonthlyD = @SalaryMonthly / @ExchangeRate;
      SET @SalaryMonthlyF = Currencys.f_Format(@CurrencyID, @SalaryMonthly);

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT INTO Gym.t_GymClass
          ( Name ,
            CurrencyID ,
            Currency ,
            PriceDaily ,
            PriceDailyF ,
            PriceDailyD ,
            PriceDailyLL ,
            PriceDailyEuro ,
            PriceWeekly ,
            PriceWeeklyF ,
            PriceWeeklyD ,
            PriceWeeklyLL ,
            PriceWeeklyEuro ,
            PriceMonthly ,
            PriceMonthlyF ,
            PriceMonthlyD ,
            PriceMonthlyLL ,
            PriceMonthlyEuro ,
            AccountEmployeeID ,
            AccountEmployee ,
            AccountEmployeeNumber ,
            SalaryDailyPercent ,
            SalaryDaily ,
            SalaryDailyF ,
            SalaryDailyD ,
            SalaryDailyLL ,
            SalaryDailyEuro ,
            SalaryWeeklyPercent ,
            SalaryWeekly ,
            SalaryWeeklyF ,
            SalaryWeeklyD ,
            SalaryWeeklyLL ,
            SalaryWeeklyEuro ,
            SalaryMonthlyPercent ,
            SalaryMonthly ,
            SalaryMonthlyF ,
            SalaryMonthlyD ,
            SalaryMonthlyLL ,
            SalaryMonthlyEuro ,
            Day0 ,
            Day0FromTime ,
            Day0ToTime ,
            Day0Minutes ,
            Day0FromToF ,
            Day1 ,
            Day1FromTime ,
            Day1ToTime ,
            Day1Minutes ,
            Day1FromToF ,
            Day2 ,
            Day2FromTime ,
            Day2ToTime ,
            Day2Minutes ,
            Day2FromToF ,
            Day3 ,
            Day3FromTime ,
            Day3ToTime ,
            Day3Minutes ,
            Day3FromToF ,
            Day4 ,
            Day4FromTime ,
            Day4ToTime ,
            Day4Minutes ,
            Day4FromToF ,
            Day5 ,
            Day5FromTime ,
            Day5ToTime ,
            Day5Minutes ,
            Day5FromToF ,
            Day6 ,
            Day6FromTime ,
            Day6ToTime ,
            Day6Minutes ,
            Day6FromToF ,
            DaysNamesAR ,
            DaysNamesEN ,
            DescriptionIs
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Name ,
            @CurrencyID ,
            Currencys.f_CurrencyGetName(@CurrencyID) ,
            @PriceDaily ,
            @PriceDailyF ,
            @PriceDailyD ,
            Currencys.f_ExchangeToLL(@CurrencyID, @PriceDaily, @PriceDailyD) ,
            Currencys.f_ExchangeToEuro(@CurrencyID, @PriceDaily, @PriceDailyD) ,
            @PriceWeekly ,
            @PriceWeeklyF ,
            @PriceWeeklyD ,
            Currencys.f_ExchangeToLL(@CurrencyID, @PriceWeekly, @PriceWeeklyD) ,
            Currencys.f_ExchangeToEuro(@CurrencyID, @PriceWeekly, @PriceWeeklyD) ,
            @PriceMonthly ,
            @PriceMonthlyF ,
            @PriceMonthlyD ,
            Currencys.f_ExchangeToLL(@CurrencyID, @PriceMonthly, @PriceMonthlyD) ,
            Currencys.f_ExchangeToEuro(@CurrencyID, @PriceMonthly, @PriceMonthlyD) ,
            @AccountEmployeeID ,
            Company.f_AccountGetName(@AccountEmployeeID) ,
            Company.f_AccountGetNumberF(@AccountEmployeeID) ,
            @SalaryDailyPercent ,
            @SalaryDaily ,
            @SalaryDailyF ,
            @SalaryDailyD ,
            Currencys.f_ExchangeToLL(@CurrencyID, @SalaryDaily, @SalaryDailyD) ,
            Currencys.f_ExchangeToEuro(@CurrencyID, @SalaryDaily, @SalaryDailyD) ,
            @SalaryWeeklyPercent ,
            @SalaryWeekly ,
            @SalaryWeeklyF ,
            @SalaryWeeklyD ,
            Currencys.f_ExchangeToLL(@CurrencyID, @SalaryWeekly, @SalaryWeeklyD) ,
            Currencys.f_ExchangeToEuro(@CurrencyID, @SalaryWeekly, @SalaryWeeklyD) ,
            @SalaryMonthlyPercent ,
            @SalaryMonthly ,
            @SalaryMonthlyF ,
            @SalaryMonthlyD ,
            Currencys.f_ExchangeToLL(@CurrencyID, @SalaryMonthly, @SalaryMonthlyD) ,
            Currencys.f_ExchangeToEuro(@CurrencyID, @SalaryMonthly, @SalaryMonthlyD) ,
            @Day0 ,
            @Day0FromTime ,
            @Day0ToTime ,
            DATEDIFF(MINUTE, @Day0FromTime, @Day0ToTime) ,
            FORMAT(@Day0FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day0ToTime, N'hh\:mm') ,
            @Day1 ,
            @Day1FromTime ,
            @Day1ToTime ,
            DATEDIFF(MINUTE, @Day1FromTime, @Day1ToTime) ,
            FORMAT(@Day1FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day1ToTime, N'hh\:mm') ,
            @Day2 ,
            @Day2FromTime ,
            @Day2ToTime ,
            DATEDIFF(MINUTE, @Day2FromTime, @Day2ToTime) ,
            FORMAT(@Day2FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day2ToTime, N'hh\:mm') ,
            @Day3 ,
            @Day3FromTime ,
            @Day3ToTime ,
            DATEDIFF(MINUTE, @Day3FromTime, @Day3ToTime) ,
            FORMAT(@Day3FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day3ToTime, N'hh\:mm') ,
            @Day4 ,
            @Day4FromTime ,
            @Day4ToTime ,
            DATEDIFF(MINUTE, @Day4FromTime, @Day4ToTime) ,
            FORMAT(@Day4FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day4ToTime, N'hh\:mm') ,
            @Day5 ,
            @Day5FromTime ,
            @Day5ToTime ,
            DATEDIFF(MINUTE, @Day5FromTime, @Day5ToTime) ,
            FORMAT(@Day5FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day5ToTime, N'hh\:mm') ,
            @Day6 ,
            @Day6FromTime ,
            @Day6ToTime ,
            DATEDIFF(MINUTE, @Day6FromTime, @Day6ToTime) ,
            FORMAT(@Day6FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day6ToTime, N'hh\:mm') ,
            [Gym].[f_GymClassGetDaysNamesAR](@Day0, @Day1, @Day2, @Day3, @Day4, @Day5, @Day6) ,
            [Gym].[f_GymClassGetDaysNamesEN](@Day0, @Day1, @Day2, @Day3, @Day4, @Day5, @Day6) ,
            @DescriptionIs
          );

      SET @ID = ( SELECT TOP ( 1 ) ID
                    FROM @IDs
                    ORDER BY ID
                );

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
        VALUES
          ( @UserID ,
            @ID ,
            @Event ,
            @EventType ,
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

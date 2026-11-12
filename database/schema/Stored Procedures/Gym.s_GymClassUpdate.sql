SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_GymClassUpdate]
  @Name NVARCHAR(MAX) ,
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
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    
    SET ANSI_WARNINGS OFF;

    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT ,
        @NameOld NVARCHAR(450) ,
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
	
      SET @NameOld = Gym.f_GymClassGetName(@ID);
      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);
      
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

      UPDATE  Gym.t_GymClass
      SET     Name = @Name ,
              CurrencyID = @CurrencyID ,
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
              PriceMonthlyEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @PriceMonthly, @PriceMonthlyD) ,
              AccountEmployeeID = @AccountEmployeeID ,
              AccountEmployee = Company.f_AccountGetName(@AccountEmployeeID) ,
              AccountEmployeeNumber = Company.f_AccountGetNumberF(@AccountEmployeeID) ,
              SalaryDailyPercent = @SalaryDailyPercent ,
              SalaryDaily = @SalaryDaily ,
              SalaryDailyF = @SalaryDailyF ,
              SalaryDailyD = @SalaryDailyD ,
              SalaryDailyLL = Currencys.f_ExchangeToLL(@CurrencyID, @SalaryDaily, @SalaryDailyD) ,
              SalaryDailyEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @SalaryDaily, @SalaryDailyD) ,
              SalaryWeeklyPercent = @SalaryWeeklyPercent ,
              SalaryWeekly = @SalaryWeekly ,
              SalaryWeeklyF = @SalaryWeeklyF ,
              SalaryWeeklyD = @SalaryWeeklyD ,
              SalaryWeeklyLL = Currencys.f_ExchangeToLL(@CurrencyID, @SalaryWeekly, @SalaryWeeklyD) ,
              SalaryWeeklyEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @SalaryWeekly, @SalaryWeeklyD) ,
              SalaryMonthlyPercent = @SalaryMonthlyPercent ,
              SalaryMonthly = @SalaryMonthly ,
              SalaryMonthlyF = @SalaryMonthlyF ,
              SalaryMonthlyD = @SalaryMonthlyD ,
              SalaryMonthlyLL = Currencys.f_ExchangeToLL(@CurrencyID, @SalaryMonthly, @SalaryMonthlyD) ,
              SalaryMonthlyEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @SalaryMonthly, @SalaryMonthlyD) ,
              Day0 = @Day0 ,
              Day0FromTime = @Day0FromTime ,
              Day0ToTime = @Day0ToTime ,
              Day0Minutes = DATEDIFF(MINUTE, @Day0FromTime, @Day0ToTime) ,
              Day0FromToF = FORMAT(@Day0FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day0ToTime, N'hh\:mm') ,
              Day1 = @Day1 ,
              Day1FromTime = @Day1FromTime ,
              Day1ToTime = @Day1ToTime ,
              Day1Minutes = DATEDIFF(MINUTE, @Day1FromTime, @Day1ToTime) ,
              Day1FromToF = FORMAT(@Day1FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day1ToTime, N'hh\:mm') ,
              Day2 = @Day2 ,
              Day2FromTime = @Day2FromTime ,
              Day2ToTime = @Day2ToTime ,
              Day2Minutes = DATEDIFF(MINUTE, @Day2FromTime, @Day2ToTime) ,
              Day2FromToF = FORMAT(@Day2FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day2ToTime, N'hh\:mm') ,
              Day3 = @Day3 ,
              Day3FromTime = @Day3FromTime ,
              Day3ToTime = @Day3ToTime ,
              Day3Minutes = DATEDIFF(MINUTE, @Day3FromTime, @Day3ToTime) ,
              Day3FromToF = FORMAT(@Day3FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day3ToTime, N'hh\:mm') ,
              Day4 = @Day4 ,
              Day4FromTime = @Day4FromTime ,
              Day4ToTime = @Day4ToTime ,
              Day4Minutes = DATEDIFF(MINUTE, @Day4FromTime, @Day4ToTime) ,
              Day4FromToF = FORMAT(@Day4FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day4ToTime, N'hh\:mm') ,
              Day5 = @Day5 ,
              Day5FromTime = @Day5FromTime ,
              Day5ToTime = @Day5ToTime ,
              Day5Minutes = DATEDIFF(MINUTE, @Day5FromTime, @Day5ToTime) ,
              Day5FromToF = FORMAT(@Day5FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day5ToTime, N'hh\:mm') ,
              Day6 = @Day6 ,
              Day6FromTime = @Day6FromTime ,
              Day6ToTime = @Day6ToTime ,
              Day6Minutes = DATEDIFF(MINUTE, @Day6FromTime, @Day6ToTime) ,
              Day6FromToF = FORMAT(@Day6FromTime, N'hh\:mm\ \-\ ') + FORMAT(@Day6ToTime, N'hh\:mm') ,
              DaysNamesAR = [Gym].[f_GymClassGetDaysNamesAR](@Day0, @Day1, @Day2, @Day3, @Day4, @Day5, @Day6) ,
              DaysNamesEN = [Gym].[f_GymClassGetDaysNamesEN](@Day0, @Day1, @Day2, @Day3, @Day4, @Day5, @Day6) ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Gym.t_GymClassMoving
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

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix

      BEGIN --t_GymSubscriptionClass

        UPDATE  Gym.t_GymSubscriptionClass
        SET     ClassName = @Name
        WHERE   ClassID = @ID;

        UPDATE  Gym.t_GymSubscriptionHistoryClass
        SET     ClassName = @Name
        WHERE   ClassID = @ID;

        UPDATE  Gym.t_GymSubscriptionDeletedClass
        SET     ClassName = @Name
        WHERE   ClassID = @ID;

      END;

      BEGIN --t_GymSubscription
	  
        DECLARE @GymSubscriptionIDs AS  TABLE ( ID UNIQUEIDENTIFIER );

        INSERT  @GymSubscriptionIDs
                ( ID
                )
        SELECT DISTINCT
                s.SubscriptionID
        FROM    Gym.t_GymSubscriptionClass AS s
        WHERE   s.ID = @ID;

        UPDATE  Gym.t_GymSubscription
        SET     ClassesNames = Alls.f_FixXML(( SELECT DISTINCT
                                                      ', ' + t1.Name AS [text()]
                                               FROM   Gym.t_GymSubscriptionClass AS t
                                               LEFT JOIN Gym.t_GymClass AS t1 ON t1.ID = t.ClassID
                                               WHERE  t.SubscriptionID = t_GymSubscription.ID
                                             FOR
                                               XML PATH('')
                                             ))
        WHERE   EXISTS ( SELECT TOP ( 1 )
                                s.ID
                         FROM   @GymSubscriptionIDs AS s
                         WHERE  s.ID = t_GymSubscription.ID );

        DELETE  FROM @GymSubscriptionIDs;
				
        INSERT  @GymSubscriptionIDs
                ( ID
                )
        SELECT DISTINCT
                s.SubscriptionID
        FROM    Gym.t_GymSubscriptionHistoryClass AS s
        WHERE   s.ID = @ID;

        UPDATE  Gym.t_GymSubscriptionHistory
        SET     ClassesNames = Alls.f_FixXML(( SELECT DISTINCT
                                                      ', ' + t1.Name AS [text()]
                                               FROM   Gym.t_GymSubscriptionHistoryClass AS t
                                               LEFT JOIN Gym.t_GymClass AS t1 ON t1.ID = t.ClassID
                                               WHERE  t.SubscriptionID = Gym.t_GymSubscriptionHistory.ID
                                             FOR
                                               XML PATH('')
                                             ))
        WHERE   EXISTS ( SELECT TOP ( 1 )
                                s.ID
                         FROM   @GymSubscriptionIDs AS s
                         WHERE  s.ID = Gym.t_GymSubscriptionHistory.ID );
  
        DELETE  FROM @GymSubscriptionIDs;
				
        INSERT  @GymSubscriptionIDs
                ( ID
                )
        SELECT DISTINCT
                s.SubscriptionID
        FROM    Gym.t_GymSubscriptionDeletedClass AS s
        WHERE   s.ID = @ID;

        UPDATE  Gym.t_GymSubscriptionDeleted
        SET     ClassesNames = Alls.f_FixXML(( SELECT DISTINCT
                                                      ', ' + t1.Name AS [text()]
                                               FROM   Gym.t_GymSubscriptionDeletedClass AS t
                                               LEFT JOIN Gym.t_GymClass AS t1 ON t1.ID = t.ClassID
                                               WHERE  t.SubscriptionID = Gym.t_GymSubscriptionDeleted.ID
                                             FOR
                                               XML PATH('')
                                             ))
        WHERE   EXISTS ( SELECT TOP ( 1 )
                                s.ID
                         FROM   @GymSubscriptionIDs AS s
                         WHERE  s.ID = Gym.t_GymSubscriptionDeleted.ID );
        
      END;

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

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_GymClassRebuildingStatistics] @UserID UNIQUEIDENTIFIER ,
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

    BEGIN --Rebuilding statistics

      SET @Return = 0;

      UPDATE Gym.t_GymClass
        SET Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
            PriceDailyF = Currencys.f_Format(CurrencyID, PriceDaily) ,
            PriceWeeklyF = Currencys.f_Format(CurrencyID, PriceWeekly) ,
            PriceMonthlyF = Currencys.f_Format(CurrencyID, PriceMonthly) ,
            AccountEmployee = Company.f_AccountGetName(AccountEmployeeID) ,
            SalaryDailyF = Currencys.f_Format(CurrencyID, SalaryDaily) ,
            SalaryWeeklyF = Currencys.f_Format(CurrencyID, SalaryWeekly) ,
            SalaryMonthlyF = Currencys.f_Format(CurrencyID, SalaryMonthly) ,
            Day0Minutes = DATEDIFF(MINUTE, Day0FromTime, Day0ToTime) ,
            Day1Minutes = DATEDIFF(MINUTE, Day1FromTime, Day1ToTime) ,
            Day2Minutes = DATEDIFF(MINUTE, Day2FromTime, Day2ToTime) ,
            Day3Minutes = DATEDIFF(MINUTE, Day3FromTime, Day3ToTime) ,
            Day4Minutes = DATEDIFF(MINUTE, Day4FromTime, Day4ToTime) ,
            Day5Minutes = DATEDIFF(MINUTE, Day5FromTime, Day5ToTime) ,
            Day6Minutes = DATEDIFF(MINUTE, Day6FromTime, Day6ToTime) ,
            Day0FromToF = FORMAT(Day0FromTime, N'hh\:mm\ \-\ ') + FORMAT(Day0ToTime, N'hh\:mm') ,
            Day1FromToF = FORMAT(Day1FromTime, N'hh\:mm\ \-\ ') + FORMAT(Day1ToTime, N'hh\:mm') ,
            Day2FromToF = FORMAT(Day2FromTime, N'hh\:mm\ \-\ ') + FORMAT(Day2ToTime, N'hh\:mm') ,
            Day3FromToF = FORMAT(Day3FromTime, N'hh\:mm\ \-\ ') + FORMAT(Day3ToTime, N'hh\:mm') ,
            Day4FromToF = FORMAT(Day4FromTime, N'hh\:mm\ \-\ ') + FORMAT(Day4ToTime, N'hh\:mm') ,
            Day5FromToF = FORMAT(Day5FromTime, N'hh\:mm\ \-\ ') + FORMAT(Day5ToTime, N'hh\:mm') ,
            Day6FromToF = FORMAT(Day6FromTime, N'hh\:mm\ \-\ ') + FORMAT(Day6ToTime, N'hh\:mm') ,
            DaysNamesAR = [Gym].[f_GymClassGetDaysNamesAR](Day0, Day1, Day2, Day3, Day4, Day5, Day6) ,
            DaysNamesEN = [Gym].[f_GymClassGetDaysNamesEN](Day0, Day1, Day2, Day3, Day4, Day5, Day6) ,
            NumberOfSubscriptions = ( SELECT COUNT(*)
                                        FROM Gym.t_GymSubscriptionClass AS s
                                        WHERE s.ClassID = t_GymClass.ID
                                    ) + ( SELECT COUNT(*)
                                            FROM Gym.t_GymSubscriptionHistoryClass AS s
                                            WHERE s.ClassID = t_GymClass.ID
                                        ) ,
            NumberOfActiveAccounts = Gym.f_GymClassGetNumberOfActiveAccounts(ID);

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
            '00000000-0000-0000-0000-000000000000' ,
            @Event ,
            6 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    COMMIT TRAN;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;








GO

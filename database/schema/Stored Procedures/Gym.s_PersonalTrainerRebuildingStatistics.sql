SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [Gym].[s_PersonalTrainerRebuildingStatistics] @UserID UNIQUEIDENTIFIER ,
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

      UPDATE Gym.t_PersonalTrainer
        SET Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
            PriceF = Currencys.f_Format(CurrencyID, Price) ,
            TotalF = Currencys.f_Format(CurrencyID, Total) ,
            AccountEmployee = Company.f_AccountGetName(AccountEmployeeID) ,
            AccountEmployeeNumber = Company.f_AccountGetNumberF(AccountEmployeeID) ,
            SalaryF = Currencys.f_Format(CurrencyID, Salary) ,
            NumberOfSubscriptions = ( SELECT COUNT(*)
                                        FROM Gym.t_GymSubscription AS s
                                        WHERE s.PersonalTrainerID = t_PersonalTrainer.ID
                                    ) + ( SELECT COUNT(*)
                                            FROM Gym.t_GymSubscriptionHistory AS s
                                            WHERE s.PersonalTrainerID = t_PersonalTrainer.ID
                                        );

      UPDATE Gym.t_PersonalTrainer
        SET NameF = [Gym].[f_PersonalTrainerNameFFix](Name, PriceF);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Gym.t_PersonalTrainerMoving
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

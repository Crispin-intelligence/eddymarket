SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_GymSubscriptionHistoryRebuildingStatistics] @UserID UNIQUEIDENTIFIER ,
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

    DISABLE TRIGGER Gym.tr_GymSubscriptionHistory ON Gym.t_GymSubscriptionHistory;
    DISABLE TRIGGER Gym.tr_GymSubscriptionHistoryClass ON Gym.t_GymSubscriptionHistoryClass;

    BEGIN --Rebuild statistics

      SET @Return = 0;

      WITH  o AS ( SELECT s.ClassID ,
                      s.ClassName ,
                      s.AccountEmployeeID ,
                      s.AccountEmployee ,
                      s1.CurrencyID ,
                      s.Price ,
                      s.PriceF ,
                      s.Salary ,
                      s.SalaryF ,
                      s.IsSync
                    FROM Gym.t_GymSubscriptionHistoryClass AS s
                    INNER JOIN Gym.t_GymSubscriptionHistory AS s1 ON s1.ID = s.SubscriptionID
                 )
        UPDATE o
          SET ClassName = Gym.f_GymClassGetName(ClassID) ,
              AccountEmployee = Company.f_AccountGetName(AccountEmployeeID) ,
              PriceF = Currencys.f_Format(CurrencyID, Price) ,
              SalaryF = Currencys.f_Format(CurrencyID, Salary) ,
              IsSync = 0;
   
      UPDATE Gym.t_GymSubscriptionHistory
        SET Account = Company.f_AccountGetName(AccountID) ,
            SubscriptionType = Gym.f_SubscriptionTypeGetName(SubscriptionTypeID) ,
            PersonalTrainer = Gym.f_PersonalTrainerGetName(PersonalTrainerID) ,
            AccountEmployee = Company.f_AccountGetName(AccountEmployeeID) ,
            NumberOfClasses = Gym.f_GymSubscriptionHistoryGetClassCount(ID) ,
            ClassesNames = Gym.f_GymSubscriptionHistoryGetClassesNames(ID) ,
            ClassesEmployeesNames = Gym.f_GymSubscriptionHistoryGetClassesEmployeesNames(ID) ,
            AccountBox = Company.f_AccountGetName(AccountBoxID) ,
            Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
            SubscriptionTypePriceF = Currencys.f_Format(CurrencyID, SubscriptionTypePrice) ,
            PersonalTrainerPriceF = Currencys.f_Format(CurrencyID, PersonalTrainerPrice) ,
            PersonalTrainerSalaryF = Currencys.f_Format(CurrencyID, PersonalTrainerSalary) ,
            ClassesPriceF = Currencys.f_Format(CurrencyID, ClassesPrice) ,
            ClassesSalaryF = Currencys.f_Format(CurrencyID, ClassesSalary) ,
            SubtotalF = Currencys.f_Format(CurrencyID, Subtotal) ,
            DiscountF = Currencys.f_Format(CurrencyID, Discount) ,
            TotalF = Currencys.f_Format(CurrencyID, Total) ,
            TotalAR = Currencys.f_ToWordAR(Total, CurrencyID, 1) ,
            TotalEN = Currencys.f_ToWordEN(Total, CurrencyID, 1) ,
            FirstPaymentF = Currencys.f_Format(CurrencyID, FirstPayment) ,
            PaymentF = Currencys.f_Format(CurrencyID, Payment) ,
            RestF = Currencys.f_Format(CurrencyID, Rest) ,
            CostF = Currencys.f_Format(CurrencyID, Cost) ,
            ProfitF = Currencys.f_Format(CurrencyID, Profit) ,
            UserIs = Users.f_UserGetName(UserID) ,
            IsSync = 0;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Gym.t_GymSubscriptionMoving
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

    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, GymSubscription, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    ENABLE TRIGGER Gym.tr_GymSubscriptionHistory ON Gym.t_GymSubscriptionHistory;
    ENABLE TRIGGER Gym.tr_GymSubscriptionHistoryClass ON Gym.t_GymSubscriptionHistoryClass;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;






GO

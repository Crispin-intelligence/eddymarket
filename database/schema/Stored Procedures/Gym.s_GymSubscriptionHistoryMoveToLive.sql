SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Gym].[s_GymSubscriptionHistoryMoveToLive] @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;
 
    END;

    BEGIN --Insert t_GymSubscription

      SET @Return = 0;

      INSERT INTO Gym.t_GymSubscription
          ( ID ,
            Ref ,
            RefF ,
            RefPaper ,
            DateIs ,
            DateMonthly ,
            DateYearly ,
            ToDate ,
            TransactionDate ,
            IsActive ,
            AccountID ,
            Account ,
            AccountNumber ,
            SubscriptionTypeID ,
            SubscriptionType ,
            PersonalTrainerID ,
            PersonalTrainer ,
            AccountEmployeeID ,
            AccountEmployee ,
            AccountEmployeeNumber ,
            NumberOfClasses ,
            ClassesNames ,
            ClassesEmployeesNames ,
            AccountBoxID ,
            AccountBox ,
            AccountBoxNumber ,
            PaymentMethod ,
            CurrencyID ,
            Currency ,
            ExchangeRate ,
            ExchangeRateLL ,
            ExchangeRateEuro ,
            SubscriptionTypePrice ,
            SubscriptionTypePriceF ,
            SubscriptionTypePriceD ,
            SubscriptionTypePriceLL ,
            SubscriptionTypePriceEuro ,
            PersonalTrainerPrice ,
            PersonalTrainerPriceF ,
            PersonalTrainerPriceD ,
            PersonalTrainerPriceLL ,
            PersonalTrainerPriceEuro ,
            PersonalTrainerSalary ,
            PersonalTrainerSalaryF ,
            PersonalTrainerSalaryD ,
            PersonalTrainerSalaryLL ,
            PersonalTrainerSalaryEuro ,
            ClassesPrice ,
            ClassesPriceF ,
            ClassesPriceD ,
            ClassesPriceLL ,
            ClassesPriceEuro ,
            ClassesSalary ,
            ClassesSalaryF ,
            ClassesSalaryD ,
            ClassesSalaryLL ,
            ClassesSalaryEuro ,
            Subtotal ,
            SubtotalF ,
            SubtotalD ,
            SubtotalLL ,
            SubtotalEuro ,
            Discount ,
            DiscountF ,
            DiscountD ,
            DiscountLL ,
            DiscountEuro ,
            Total ,
            TotalF ,
            TotalD ,
            TotalLL ,
            TotalEuro ,
            TotalAR ,
            TotalEN ,
            FirstPayment ,
            FirstPaymentF ,
            FirstPaymentD ,
            FirstPaymentLL ,
            FirstPaymentEuro ,
            Payment ,
            PaymentF ,
            PaymentD ,
            PaymentLL ,
            PaymentEuro ,
            Rest ,
            RestF ,
            RestD ,
            RestLL ,
            RestEuro ,
            IsPaid ,
            IsPaidSalary ,
            AreClassesSalariesPaid ,
            Cost ,
            CostF ,
            CostD ,
            CostLL ,
            CostEuro ,
            Profit ,
            ProfitF ,
            ProfitD ,
            ProfitLL ,
            ProfitEuro ,
            UserID ,
            UserIs ,
            DescriptionIs ,
            DateCreate ,
            IsSync ,
            WorkStationID
          )
        SELECT t.ID ,
            t.Ref ,
            t.RefF ,
            t.RefPaper ,
            t.DateIs ,
            t.DateMonthly ,
            t.DateYearly ,
            t.ToDate ,
            t.TransactionDate ,
            t.IsActive ,
            t.AccountID ,
            t.Account ,
            t.AccountNumber ,
            t.SubscriptionTypeID ,
            t.SubscriptionType ,
            t.PersonalTrainerID ,
            t.PersonalTrainer ,
            t.AccountEmployeeID ,
            t.AccountEmployee ,
            t.AccountEmployeeNumber ,
            t.NumberOfClasses ,
            t.ClassesNames ,
            t.ClassesEmployeesNames ,
            t.AccountBoxID ,
            t.AccountBox ,
            t.AccountBoxNumber ,
            t.PaymentMethod ,
            t.CurrencyID ,
            t.Currency ,
            t.ExchangeRate ,
            t.ExchangeRateLL ,
            t.ExchangeRateEuro ,
            t.SubscriptionTypePrice ,
            t.SubscriptionTypePriceF ,
            t.SubscriptionTypePriceD ,
            t.SubscriptionTypePriceLL ,
            t.SubscriptionTypePriceEuro ,
            t.PersonalTrainerPrice ,
            t.PersonalTrainerPriceF ,
            t.PersonalTrainerPriceD ,
            t.PersonalTrainerPriceLL ,
            t.PersonalTrainerPriceEuro ,
            t.PersonalTrainerSalary ,
            t.PersonalTrainerSalaryF ,
            t.PersonalTrainerSalaryD ,
            t.PersonalTrainerSalaryLL ,
            t.PersonalTrainerSalaryEuro ,
            t.ClassesPrice ,
            t.ClassesPriceF ,
            t.ClassesPriceD ,
            t.ClassesPriceLL ,
            t.ClassesPriceEuro ,
            t.ClassesSalary ,
            t.ClassesSalaryF ,
            t.ClassesSalaryD ,
            t.ClassesSalaryLL ,
            t.ClassesSalaryEuro ,
            t.Subtotal ,
            t.SubtotalF ,
            t.SubtotalD ,
            t.SubtotalLL ,
            t.SubtotalEuro ,
            t.Discount ,
            t.DiscountF ,
            t.DiscountD ,
            t.DiscountLL ,
            t.DiscountEuro ,
            t.Total ,
            t.TotalF ,
            t.TotalD ,
            t.TotalLL ,
            t.TotalEuro ,
            t.TotalAR ,
            t.TotalEN ,
            t.FirstPayment ,
            t.FirstPaymentF ,
            t.FirstPaymentD ,
            t.FirstPaymentLL ,
            t.FirstPaymentEuro ,
            t.Payment ,
            t.PaymentF ,
            t.PaymentD ,
            t.PaymentLL ,
            t.PaymentEuro ,
            t.Rest ,
            t.RestF ,
            t.RestD ,
            t.RestLL ,
            t.RestEuro ,
            t.IsPaid ,
            t.IsPaidSalary ,
            t.AreClassesSalariesPaid ,
            t.Cost ,
            t.CostF ,
            t.CostD ,
            t.CostLL ,
            t.CostEuro ,
            t.Profit ,
            t.ProfitF ,
            t.ProfitD ,
            t.ProfitLL ,
            t.ProfitEuro ,
            t.UserID ,
            t.UserIs ,
            t.DescriptionIs ,
            t.DateCreate ,
            t.IsSync ,
            t.WorkStationID
          FROM Gym.t_GymSubscriptionHistory AS t
          WHERE t.ID = @ID;

    END;

    BEGIN --Insert t_GymSubscriptionClass
	 
      INSERT INTO Gym.t_GymSubscriptionClass
          ( ID ,
            SubscriptionID ,
            ClassID ,
            ClassName ,
            AccountEmployeeID ,
            AccountEmployee ,
            AccountEmployeeNumber ,
            Price ,
            PriceF ,
            PriceD ,
            PriceLL ,
            PriceEuro ,
            SalaryPercent ,
            Salary ,
            SalaryF ,
            SalaryD ,
            SalaryLL ,
            SalaryEuro ,
            IsSalaryPaid ,
            DescriptionIs ,
            DateCreate ,
            IsSync ,
            WorkStationID
          )
        SELECT t.ID ,
            t.SubscriptionID ,
            t.ClassID ,
            t.ClassName ,
            t.AccountEmployeeID ,
            t.AccountEmployee ,
            t.AccountEmployeeNumber ,
            t.Price ,
            t.PriceF ,
            t.PriceD ,
            t.PriceLL ,
            t.PriceEuro ,
            t.SalaryPercent ,
            t.Salary ,
            t.SalaryF ,
            t.SalaryD ,
            t.SalaryLL ,
            t.SalaryEuro ,
            t.IsSalaryPaid ,
            t.DescriptionIs ,
            t.DateCreate ,
            t.IsSync ,
            t.WorkStationID
          FROM Gym.t_GymSubscriptionHistoryClass AS t
          WHERE t.SubscriptionID = @ID;

    END;

    BEGIN --Delete
				
      DELETE FROM Gym.t_GymSubscriptionHistoryClass
        WHERE SubscriptionID = @ID;

      DELETE FROM Gym.t_GymSubscriptionHistory
        WHERE ID = @ID;

    END;

    BEGIN --Fix t_GymClass

      UPDATE Gym.t_GymClass
        SET NumberOfActiveAccounts = Gym.f_GymClassGetNumberOfActiveAccounts(ID)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM Gym.t_GymSubscriptionClass AS s
                        WHERE s.ClassID = t_GymClass.ID AND s.SubscriptionID = @ID );

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
            @ID ,
            @Event ,
            2 ,
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

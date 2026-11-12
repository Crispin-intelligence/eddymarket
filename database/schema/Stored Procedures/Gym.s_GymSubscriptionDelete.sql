SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Gym].[s_GymSubscriptionDelete] @UserID UNIQUEIDENTIFIER ,
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

      DECLARE @DateIs DATE ,
        @ToDate DATE ,
        @AccountID UNIQUEIDENTIFIER ,
        @SubscriptionTypeID UNIQUEIDENTIFIER ,
        @PersonalTrainerID UNIQUEIDENTIFIER ,
        @TotalD FLOAT ,
        @TotalLL FLOAT ,
        @TotalEuro FLOAT ,
        @Return INT;
 
    END;

    BEGIN --Set info
	    
      SELECT TOP ( 1 ) @DateIs = s.DateIs ,
          @ToDate = s.ToDate ,
          @AccountID = s.AccountID ,
          @SubscriptionTypeID = s.SubscriptionTypeID ,
          @PersonalTrainerID = s.PersonalTrainerID ,
          @TotalD = s.TotalD ,
          @TotalLL = s.TotalLL ,
          @TotalEuro = s.TotalEuro
        FROM Gym.t_GymSubscription AS s
        WHERE s.ID = @ID;

    END;

    BEGIN --Insert t_GymSubscriptionDeleted

      SET @Return = 0;

      INSERT INTO Gym.t_GymSubscriptionDeleted
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
          FROM Gym.t_GymSubscription AS t
          WHERE t.ID = @ID;

    END;

    BEGIN --Insert t_GymSubscriptionDeletedClass
	 
      INSERT INTO Gym.t_GymSubscriptionDeletedClass
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
          FROM Gym.t_GymSubscriptionClass AS t
          WHERE t.SubscriptionID = @ID;

    END;

    BEGIN --Delete
				
      DELETE FROM Gym.t_GymSubscriptionClass
        WHERE SubscriptionID = @ID;

      DELETE FROM Gym.t_GymSubscription
        WHERE ID = @ID;

    END;

    BEGIN --Delete t_Transaction

      DELETE FROM Transactions.t_Transaction
        WHERE LinkType = 174 AND LinkID = @ID;

    END;

    BEGIN --Fix t_GymActiveVSAttendance

      EXECUTE Gym.s_GymActiveVSAttendanceMerge @DateIs, @ToDate, 1, 0; 
	  
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
            @EventType ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    BEGIN --Fix t_Account GymSubscription

      UPDATE Company.t_Account
        SET GymSubscriptionC = [Gym].f_GymSubscriptionGetCountByAccountID(ID) ,
            GymSubscriptionLast = [Gym].f_GymSubscriptionGetLastByAccountID(ID) ,
            GymSubscriptionTotal = [Gym].[f_GymSubscriptionGetTotalByAccountID](ID) ,
            GymSubscriptionProfit = [Gym].[f_GymSubscriptionGetProfitByAccountID](ID) ,
            GymSubscriptionActiveTo = [Gym].f_GymSubscriptionGetActiveToByAccountID(ID)
        WHERE ID = @AccountID;

      UPDATE Company.t_Account
        SET GymSubscriptionTotalF = Currencys.f_Format(CurrencyID, GymSubscriptionTotal) ,
            GymSubscriptionProfitF = Currencys.f_Format(CurrencyID, GymSubscriptionProfit) ,
            GymSubscriptionIsActive = IIF(GymSubscriptionActiveTo >= CONVERT(DATE, GETDATE()), 1, 0)
        WHERE ID = @AccountID;
		  
    END;

    BEGIN --Fix t_SubscriptionType

      UPDATE Gym.t_SubscriptionType
        SET NumberOfSubscriptions -= 1
        WHERE ID = @SubscriptionTypeID;

    END;

    BEGIN --Fix t_PersonalTrainer

      UPDATE Gym.t_PersonalTrainer
        SET NumberOfSubscriptions -= 1
        WHERE ID = @PersonalTrainerID;

    END;

    BEGIN --Fix t_GymClass

      UPDATE Gym.t_GymClass
        SET NumberOfSubscriptions -= ( SELECT COUNT(*)
                                        FROM Gym.t_GymSubscriptionDeletedClass AS s
                                        WHERE s.ClassID = t_GymClass.ID AND s.SubscriptionID = @ID
                                     ) ,
            NumberOfActiveAccounts = Gym.f_GymClassGetNumberOfActiveAccounts(ID)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM Gym.t_GymSubscriptionDeletedClass AS s
                        WHERE s.ClassID = t_GymClass.ID AND s.SubscriptionID = @ID );

    END;
		  
    BEGIN --Fix t_ProfitDaily

      SET @TotalD = 0 - @TotalD;
      SET @TotalLL = 0 - @TotalLL;
      SET @TotalEuro = 0 - @TotalEuro;

      EXECUTE Invoices.s_ProfitDailyGymSubscriptionMergePART @DateIs, @TotalD, @TotalLL, @TotalEuro; 
	  
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

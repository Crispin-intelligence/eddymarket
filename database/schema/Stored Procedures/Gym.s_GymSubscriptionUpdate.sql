SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_GymSubscriptionUpdate] @RefPaper NVARCHAR(MAX) ,
  @DateIs DATE ,
  @TransactionDate DATE ,
  @AccountID UNIQUEIDENTIFIER ,
  @SubscriptionTypeID UNIQUEIDENTIFIER ,
  @PersonalTrainerID UNIQUEIDENTIFIER ,
  @AccountEmployeeID UNIQUEIDENTIFIER ,
  @AccountEmployeeSalaryID UNIQUEIDENTIFIER ,
  @AccountBoxID UNIQUEIDENTIFIER ,
  @PaymentMethod TINYINT ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @ExchangeRate DECIMAL(18, 2) ,
  @ExchangeRateLL DECIMAL(18, 2) ,
  @ExchangeRateEuro DECIMAL(18, 2) ,
  @SubscriptionTypePrice FLOAT ,
  @PersonalTrainerPrice FLOAT ,
  @PersonalTrainerSalary FLOAT ,
  @Discount FLOAT ,
  @FirstPayment FLOAT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @SaleID UNIQUEIDENTIFIER ,
  @Classes Gym.tt_GymSubscriptionClass READONLY ,
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

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @TransactionIDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          RefF NVARCHAR(MAX) NOT NULL
        );

      DECLARE @RefF NVARCHAR(MAX) ,
        @DateIsOld DATE ,
        @ToDate DATE ,
        @ToDateOld DATE ,
        @IsActive BIT ,
        @AccountIDOld UNIQUEIDENTIFIER ,
        @Account NVARCHAR(MAX) ,
        @AccountNumber NVARCHAR(MAX) ,
        @DoorID NVARCHAR(MAX) ,
        @SubscriptionTypeIDOld UNIQUEIDENTIFIER ,
        @SubscriptionType NVARCHAR(MAX) ,
        @PersonalTrainerIDOld UNIQUEIDENTIFIER ,
        @PersonalTrainer NVARCHAR(MAX) ,
        @AccountEmployee NVARCHAR(MAX) ,
        @AccountEmployeeNumber NVARCHAR(MAX) ,
        @AccountEmployeeSalary NVARCHAR(MAX) ,
        @NumberOfClasses NVARCHAR(MAX) ,
        @ClassesNames NVARCHAR(MAX) ,
        @ClassesEmployeesNames NVARCHAR(MAX) ,
        @AccountBox NVARCHAR(MAX) ,
        @AccountBoxNumber NVARCHAR(MAX) ,
        @Currency NVARCHAR(MAX) ,
        @SubscriptionTypePriceD FLOAT ,
        @PersonalTrainerPriceD FLOAT ,
        @PersonalTrainerSalaryD FLOAT ,
        @ClassesPrice FLOAT ,
        @ClassesPriceD FLOAT ,
        @ClassesSalary FLOAT ,
        @ClassesSalaryD FLOAT ,
        @Subtotal FLOAT ,
        @SubtotalD FLOAT ,
        @DiscountD FLOAT ,
        @TotalD FLOAT ,
        @TotalLL FLOAT ,
        @TotalEuro FLOAT ,
        @Total FLOAT ,
        @TotalDOld FLOAT ,
        @TotalLLOld FLOAT ,
        @TotalEuroOld FLOAT ,
        @FirstPaymentD FLOAT ,
        @Rest FLOAT ,
        @RestD FLOAT ,
        @IsPaid BIT ,
        @AreClassesSalariesPaid BIT ,
        @Cost FLOAT ,
        @CostD FLOAT ,
        @Profit FLOAT ,
        @ProfitD FLOAT ,
        @UserIs NVARCHAR(MAX) ,
        @Sale NVARCHAR(MAX) ,
        @TrnID UNIQUEIDENTIFIER ,
        @TrnRef BIGINT ,
        @TrnRefJVOld BIGINT ,
        @TrnRefRVOld BIGINT ,
        @TrnStatementBase NVARCHAR(MAX) ,
        @TrnStatement NVARCHAR(MAX) ,
        @TrnRN INT ,
        @TrnLinkType TINYINT = 174 ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @VD FLOAT ,
        @return INT;

    END;

    BEGIN --Set info.

      SELECT TOP ( 1 ) @RefF = s.RefF ,
          @DateIsOld = s.DateIs ,
          @ToDateOld = s.ToDate ,
          @AccountIDOld = s.AccountID ,
          @SubscriptionTypeIDOld = s.SubscriptionTypeID ,
          @PersonalTrainerIDOld = s.PersonalTrainerID ,
          @TotalDOld = s.TotalD ,
          @TotalLLOld = s.TotalLL ,
          @TotalEuroOld = s.TotalEuro
        FROM Gym.t_GymSubscription AS s
        WHERE ID = @ID;

      SET @ToDate = Gym.f_GymSubscriptionToDate(@SubscriptionTypeID, @DateIs);

      SET @IsActive = CONVERT(BIT, IIF(@ToDate >= CONVERT(DATE, GETDATE()), 1, 0));

      SET @Account = Company.f_AccountGetName(@AccountID);
      SET @AccountNumber = Company.f_AccountGetNumberF(@AccountID);
      SET @DoorID = FORMAT(Customers.f_CustomerGetIDDoorByAccount(@AccountID), 'n0');

      SET @SubscriptionType = Gym.f_SubscriptionTypeGetName(@SubscriptionTypeID);
     
      SET @PersonalTrainer = Gym.f_PersonalTrainerGetName(@PersonalTrainerID);
  
      SET @AccountEmployee = Company.f_AccountGetName(@AccountEmployeeID);
      SET @AccountEmployeeNumber = Company.f_AccountGetNumberF(@AccountEmployeeID);
      SET @AccountEmployeeSalary = Company.f_AccountGetName(@AccountEmployeeSalaryID);
	 
      SELECT @NumberOfClasses = COUNT(*)
        FROM @Classes AS s;
      SET @ClassesNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + s1.Name AS [text()]
                                            FROM @Classes AS s
                                            INNER JOIN Gym.t_GymClass AS s1 ON s1.ID = s.ClassID
                                        FOR
                                          XML PATH('')
                                        ));
      SET @ClassesEmployeesNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + s1.Name AS [text()]
                                                    FROM @Classes AS s
                                                    INNER JOIN Company.t_Account AS s1 ON s1.ID = s.AccountEmployeeID
                                                 FOR
                                                   XML PATH('')
                                                 ));

      SET @AccountBox = Company.f_AccountGetName(@AccountBoxID);
      SET @AccountBoxNumber = Company.f_AccountGetNumberF(@AccountBoxID);

      SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);

      SET @SubscriptionTypePriceD = @SubscriptionTypePrice / @ExchangeRate;
      SET @PersonalTrainerPriceD = @PersonalTrainerPrice / @ExchangeRate;
      SET @PersonalTrainerSalaryD = @PersonalTrainerSalary / @ExchangeRate;
      SELECT @ClassesPrice = COALESCE(SUM(s.Price), 0) ,
          @ClassesSalary = COALESCE(SUM(s.Salary), 0)
        FROM @Classes AS s;
      SET @ClassesPriceD = @ClassesPrice / @ExchangeRate;
      SET @ClassesSalaryD = @ClassesSalary / @ExchangeRate;
      SET @Subtotal = @SubscriptionTypePrice + @PersonalTrainerPrice + @ClassesPrice;
      SET @SubtotalD = @Subtotal / @ExchangeRate;
      SET @DiscountD = @Discount / @ExchangeRate;
      SET @Total = @Subtotal - @Discount;
      SET @TotalD = @Total / @ExchangeRate;
      SET @TotalLL = @TotalD * @ExchangeRateLL;
      SET @TotalEuro = @TotalD * @ExchangeRateEuro;
      SET @FirstPaymentD = @FirstPayment / @ExchangeRate;
      SET @Rest = @Total - @FirstPayment;
      SET @RestD = @Rest / @ExchangeRate;
      SET @IsPaid = IIF(@Rest <= 0, 1, 0);
      SET @AreClassesSalariesPaid = IIF(@ClassesSalary <= 0, 1, 0);

      SET @Cost = @PersonalTrainerSalary + COALESCE(( SELECT SUM(s.Salary)
                                                        FROM @Classes AS s
                                                    ), 0);
      SET @CostD = @Cost / @ExchangeRate;

      SET @Profit = @Total - @Cost;
      SET @ProfitD = @Profit / @ExchangeRate;

      SET @Sale = Company.f_AccountGetName(@SaleID);
	  
      SET @UserIs = Users.f_UserGetName(@UserID);
      
      SELECT TOP ( 1 ) @TrnRefJVOld = s.Ref
        FROM Transactions.t_Transaction AS s
        WHERE s.LinkType = @TrnLinkType AND s.LinkID = @ID AND s.TypeIs = N'JV';
        
      SELECT TOP ( 1 ) @TrnRefRVOld = s.Ref
        FROM Transactions.t_Transaction AS s
        WHERE s.LinkType = @TrnLinkType AND s.LinkID = @ID AND s.TypeIs = N'RV';

      SET @TrnStatementBase = N'GS:' + @RefF;
	       
      SET @TrnRN = 0;  
      SET @CID = @CurrencyID;
      SET @E = @ExchangeRate;
      SET @ELL = @ExchangeRateLL;
      SET @EEuro = @ExchangeRateEuro;  
		      
    END;

    BEGIN --Insert

      SET @return = 0;

      UPDATE Gym.t_GymSubscription
        SET RefPaper = @RefPaper ,
            DateIs = @DateIs ,
            DateMonthly = DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
            DateYearly = DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
            ToDate = @ToDate ,
            TransactionDate = @TransactionDate ,
            IsActive = @IsActive ,
            AccountID = @AccountID ,
            Account = @Account ,
            AccountNumber = @AccountNumber ,
            SubscriptionTypeID = @SubscriptionTypeID ,
            SubscriptionType = @SubscriptionType ,
            PersonalTrainerID = @PersonalTrainerID ,
            PersonalTrainer = @PersonalTrainer ,
            AccountEmployeeID = @AccountEmployeeID ,
            AccountEmployee = @AccountEmployee ,
            AccountEmployeeNumber = @AccountEmployeeNumber ,
            NumberOfClasses = @NumberOfClasses ,
            ClassesNames = @ClassesNames ,
            ClassesEmployeesNames = @ClassesEmployeesNames ,
            AccountBoxID = @AccountBoxID ,
            AccountBox = @AccountBox ,
            AccountBoxNumber = @AccountBoxNumber ,
            PaymentMethod = @PaymentMethod ,
            CurrencyID = @CurrencyID ,
            Currency = @Currency ,
            ExchangeRate = @ExchangeRate ,
            ExchangeRateLL = @ExchangeRateLL ,
            ExchangeRateEuro = @ExchangeRateEuro ,
            SubscriptionTypePrice = @SubscriptionTypePrice ,
            SubscriptionTypePriceF = Currencys.f_Format(@CID, @SubscriptionTypePrice) ,
            SubscriptionTypePriceD = @SubscriptionTypePriceD ,
            SubscriptionTypePriceLL = @SubscriptionTypePriceD * @ELL ,
            SubscriptionTypePriceEuro = @SubscriptionTypePriceD * @EEuro ,
            PersonalTrainerPrice = @PersonalTrainerPrice ,
            PersonalTrainerPriceF = Currencys.f_Format(@CID, @PersonalTrainerPrice) ,
            PersonalTrainerPriceD = @PersonalTrainerPriceD ,
            PersonalTrainerPriceLL = @PersonalTrainerPriceD * @ELL ,
            PersonalTrainerPriceEuro = @PersonalTrainerPriceD * @EEuro ,
            PersonalTrainerSalary = @PersonalTrainerSalary ,
            PersonalTrainerSalaryF = Currencys.f_Format(@CID, @PersonalTrainerSalary) ,
            PersonalTrainerSalaryD = @PersonalTrainerSalaryD ,
            PersonalTrainerSalaryLL = @PersonalTrainerSalaryD * @ELL ,
            PersonalTrainerSalaryEuro = @PersonalTrainerSalaryD * @EEuro ,
            ClassesPrice = @ClassesPrice ,
            ClassesPriceF = Currencys.f_Format(@CID, @ClassesPrice) ,
            ClassesPriceD = @ClassesPriceD ,
            ClassesPriceLL = @ClassesPriceD * @ELL ,
            ClassesPriceEuro = @ClassesPriceD * @EEuro ,
            ClassesSalary = @ClassesSalary ,
            ClassesSalaryF = Currencys.f_Format(@CID, @ClassesSalary) ,
            ClassesSalaryD = @ClassesSalaryD ,
            ClassesSalaryLL = @ClassesSalaryD * @ELL ,
            ClassesSalaryEuro = @ClassesSalaryD * @EEuro ,
            Subtotal = @Subtotal ,
            SubtotalF = Currencys.f_Format(@CID, @Subtotal) ,
            SubtotalD = @SubtotalD ,
            SubtotalLL = @SubtotalD * @ELL ,
            SubtotalEuro = @SubtotalD * @EEuro ,
            Discount = @Discount ,
            DiscountF = Currencys.f_Format(@CID, @Discount) ,
            DiscountD = @DiscountD ,
            DiscountLL = @DiscountD * @ELL ,
            DiscountEuro = @DiscountD * @EEuro ,
            Total = @Total ,
            TotalF = Currencys.f_Format(@CID, @Total) ,
            TotalD = @TotalD ,
            TotalLL = @TotalLL ,
            TotalEuro = @TotalEuro ,
            TotalAR = Currencys.f_ToWordAR(@Total, @CID, 1) ,
            TotalEN = Currencys.f_ToWordEN(@Total, @CID, 1) ,
            FirstPayment = @FirstPayment ,
            FirstPaymentF = Currencys.f_Format(@CID, @FirstPayment) ,
            FirstPaymentD = @FirstPaymentD ,
            FirstPaymentLL = @FirstPaymentD * @ELL ,
            FirstPaymentEuro = @FirstPaymentD * @EEuro ,
            Payment = @FirstPayment ,
            PaymentF = Currencys.f_Format(@CID, @FirstPayment) ,
            PaymentD = @FirstPaymentD ,
            PaymentLL = @FirstPaymentD * @ELL ,
            PaymentEuro = @FirstPaymentD * @EEuro ,
            Rest = @Rest ,
            RestF = Currencys.f_Format(@CID, @Rest) ,
            RestD = @RestD ,
            RestLL = @RestD * @ELL ,
            RestEuro = @RestD * @EEuro ,
            IsPaid = @IsPaid ,
            IsPaidSalary = IIF(@PersonalTrainerSalary > 0, 0, 1) ,
            AreClassesSalariesPaid = @AreClassesSalariesPaid ,
            Cost = @Cost ,
            CostF = Currencys.f_Format(@CID, @Cost) ,
            CostD = @CostD ,
            CostLL = @CostD * @ELL ,
            CostEuro = @CostD * @EEuro ,
            Profit = @Profit ,
            ProfitF = Currencys.f_Format(@CID, @Profit) ,
            ProfitD = @ProfitD ,
            ProfitLL = @ProfitD * @ELL ,
            ProfitEuro = @ProfitD * @EEuro ,
            UserID = @UserID ,
            UserIs = @UserIs ,
            DescriptionIs = @DescriptionIs
        WHERE ID = @ID;

    END;
		
    BEGIN --Fix t_GymClass

      UPDATE Gym.t_GymClass
        SET NumberOfSubscriptions -= ( SELECT COUNT(*)
                                        FROM Gym.t_GymSubscriptionClass AS s
                                        WHERE s.SubscriptionID = @ID AND s.ClassID = t_GymClass.ID
                                     )
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM Gym.t_GymSubscriptionClass AS s
                        WHERE s.SubscriptionID = @ID AND s.ClassID = t_GymClass.ID );

    END;

    BEGIN --Reinsert t_GymSubscriptionClass

      DELETE FROM Gym.t_GymSubscriptionClass
        WHERE SubscriptionID = @ID;

      INSERT INTO Gym.t_GymSubscriptionClass
          ( SubscriptionID ,
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
            DescriptionIs
          )
        SELECT @ID ,
            s.ClassID ,
            Gym.f_GymClassGetName(s.ClassID) ,
            s.AccountEmployeeID ,
            Company.f_AccountGetName(s.AccountEmployeeID) ,
            Company.f_AccountGetNumberF(s.AccountEmployeeID) ,
            s.Price ,
            Currencys.f_Format(@CID, s.Price) ,
            s.Price / @E ,
            s.Price / @E * @ELL ,
            s.Price / @E * @EEuro ,
            s.SalaryPercent ,
            s.Salary ,
            Currencys.f_Format(@CID, s.Salary) ,
            s.Salary / @E ,
            s.Salary / @E * @ELL ,
            s.Salary / @E * @EEuro ,
            0 ,
            s.DescriptionIs
          FROM @Classes AS s;

    END;

    BEGIN --Insert Event

      SET @return = -1;

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
	
    BEGIN --Delete t_Transaction

      DELETE FROM Transactions.t_Transaction
        WHERE LinkType = @TrnLinkType AND LinkID = @ID;

    END;
    
    IF @Total > 0 OR @PersonalTrainerSalary > 0 OR @ClassesSalary > 0
    BEGIN --Transaction

      BEGIN --Set info

        SET @TrnRef = COALESCE(@TrnRefJVOld, ( SELECT ISNULL(MAX(s.Ref), 0) + 1
                                                FROM Transactions.t_Transaction AS s
                                                WHERE s.TypeIs = N'JV'
                                             ));

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE FROM @IDs;

        INSERT INTO Transactions.t_Transaction
            ( Ref ,
              TypeIs ,
              DateIs ,
              DescriptionIs ,
              LinkType ,
              LinkID ,
              UserID
            )
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @TrnRef ,
              N'JV' ,
              @TransactionDate ,
              @TrnStatementBase ,
              @TrnLinkType ,
              @ID ,
              @UserID
            );

        SET @TrnID = ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        ORDER BY s.ID
                     );

        INSERT @TransactionIDs
            ( ID ,
              RefF
            )
          VALUES
            ( @TrnID ,
              CONVERT(NVARCHAR(MAX), @TrnRef)
            );

      END;
  
      IF @Total > 0
      BEGIN --Insert detail
			
        SET @V = @Total;
        SET @TrnRN = 1;
        SET @TrnStatement = @SubscriptionType + N' \ ' + @TrnStatementBase;
        EXECUTE Transactions.s_TransactionDetailInsertDebit @TrnRN, @TrnID, @AccountID, @TransactionDate, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;
       
        SET @TrnRN += 1;
        SET @TrnStatement = @DoorID + N' \ ' + @Account + N' \ ' + @SubscriptionType + N' \ ' + @TrnStatementBase;
        EXECUTE Transactions.s_TransactionDetailInsertCredit @TrnRN, @TrnID, @SaleID, @TransactionDate, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;

      END;

    END;

    IF @PersonalTrainerSalary > 0
    BEGIN --Insert detail

      SET @V = @PersonalTrainerSalary;
      SET @TrnRN += 1;
      SET @TrnStatement = @DoorID + N' \ ' + @Account + N' \ ' + @SubscriptionType + N' \ ' + @TrnStatementBase;
      EXECUTE Transactions.s_TransactionDetailInsertDebit @TrnRN, @TrnID, @AccountEmployeeSalaryID, @TransactionDate, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;
       
      SET @TrnRN += 1;
      SET @TrnStatement = @DoorID + N' \ ' + @Account + N' \ ' + @SubscriptionType + N' \ ' + @TrnStatementBase;
      EXECUTE Transactions.s_TransactionDetailInsertCredit @TrnRN, @TrnID, @AccountEmployeeID, @TransactionDate, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;

    END;

    IF @NumberOfClasses > 0
    BEGIN --Insert detail

      DECLARE @ID_ UNIQUEIDENTIFIER ,
        @AccountEmployeeID_ UNIQUEIDENTIFIER ,
        @AccountEmployeeSalaryID_ UNIQUEIDENTIFIER;

      DECLARE Salaries CURSOR FORWARD_ONLY
      FOR
      SELECT t.ID
        FROM @Classes AS t
        WHERE t.Salary > 0;

      OPEN Salaries;
      FETCH NEXT FROM Salaries
            INTO @ID_;

      WHILE @@FETCH_STATUS = 0
      BEGIN -- Insert data
		
        SELECT TOP ( 1 ) @AccountEmployeeID_ = s.AccountEmployeeID ,
            @V = s.Salary
          FROM @Classes AS s
          WHERE s.ID = @ID_;

        SET @AccountEmployeeSalaryID_ = Company.f_AccountGetEmployeeSalaryIDByAccountID(@AccountEmployeeID_);
	
        SET @TrnRN += 1;
        SET @TrnStatement = @DoorID + N' \ ' + @Account + N' \ ' + @SubscriptionType + N' \ ' + @TrnStatementBase;
        EXECUTE Transactions.s_TransactionDetailInsertDebit @TrnRN, @TrnID, @AccountEmployeeSalaryID_, @TransactionDate, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;
       
        SET @TrnRN += 1;
        SET @TrnStatement = @DoorID + N' \ ' + @Account + N' \ ' + @SubscriptionType + N' \ ' + @TrnStatementBase;
        EXECUTE Transactions.s_TransactionDetailInsertCredit @TrnRN, @TrnID, @AccountEmployeeID_, @TransactionDate, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;
	  			
        FETCH NEXT FROM Salaries
                INTO @ID_;

      END;

      CLOSE Salaries;

      DEALLOCATE Salaries;

    END;

    IF @FirstPayment > 0
    BEGIN --Transaction

      BEGIN --Set info

        SET @TrnRef = COALESCE(@TrnRefRVOld, ( SELECT ISNULL(MAX(s.Ref), 0) + 1
                                                FROM Transactions.t_Transaction AS s
                                                WHERE s.TypeIs = N'RV'
                                             ));


      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE FROM @IDs;

        INSERT INTO Transactions.t_Transaction
            ( Ref ,
              TypeIs ,
              DateIs ,
              DescriptionIs ,
              LinkType ,
              LinkID ,
              UserID
            )
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @TrnRef ,
              N'RV' ,
              @TransactionDate ,
              @TrnStatementBase ,
              @TrnLinkType ,
              @ID ,
              @UserID
            );

        SET @TrnID = ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        ORDER BY s.ID
                     );

        INSERT @TransactionIDs
            ( ID ,
              RefF
            )
          VALUES
            ( @TrnID ,
              CONVERT(NVARCHAR(MAX), @TrnRef)
            );

      END;

      BEGIN --Insert detail

        SET @V = @FirstPayment;
        SET @TrnRN = 1;
        SET @TrnStatement = @DoorID + N' \ ' + @Account + N' \ ' + @SubscriptionType + N' \ ' + @TrnStatementBase;
        EXECUTE Transactions.s_TransactionDetailInsertDebit @TrnRN, @TrnID, @AccountBoxID, @TransactionDate, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;
       
        SET @TrnRN += 1;
        SET @TrnStatement = @SubscriptionType + N' \ ' + @TrnStatementBase;
        EXECUTE Transactions.s_TransactionDetailInsertCredit @TrnRN, @TrnID, @AccountID, @TransactionDate, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;

      END;

    END;

    BEGIN --Insert t_TransactionMoving

      SET @return = -1;

      INSERT INTO Transactions.t_TransactionMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        SELECT @UserID ,
            @TrnID ,
            @Event + s.RefF ,
            @EventType ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          FROM @TransactionIDs AS s;

    END;

    BEGIN --Fix data

      UPDATE Company.t_Account
        SET StatusIs = 0 ,
            LastAction = GETDATE()
        WHERE ( ID IN ( @AccountID, @AccountEmployeeID, @AccountEmployeeSalaryID, @AccountBoxID, @SaleID ) AND StatusIs = 1
              ) OR ( EXISTS ( SELECT TOP ( 1 ) s.ID
                                FROM @Classes AS s
                                WHERE s.AccountEmployeeID = t_Account.ID ) AND StatusIs = 1
                   );
               
      UPDATE Transactions.t_Transaction
        SET RefF = FORMAT(Ref, 'n0') ,
            DateOnly = DateIs ,
            DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
            DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
            AccountsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t.Account AS [text()]
                                              FROM Transactions.t_TransactionDetail AS t
                                              WHERE t.TransactionID = @TrnID
                                          FOR
                                            XML PATH('')
                                          )) ,
            BalanceD = COALESCE(( SELECT SUM(s.Balance)
                                    FROM Transactions.t_TransactionDetail AS s
                                    WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 0 AND s.Balance > 0
                                ), 0) ,
            BalanceLL = COALESCE(( SELECT SUM(s.Balance)
                                    FROM Transactions.t_TransactionDetail AS s
                                    WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 1 AND s.Balance > 0
                                 ), 0) ,
            BalanceEuro = COALESCE(( SELECT SUM(s.Balance)
                                      FROM Transactions.t_TransactionDetail AS s
                                      WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 2 AND s.Balance > 0
                                   ), 0) ,
            UserIs = Users.f_UserGetName(UserID)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @TransactionIDs AS s
                        WHERE s.ID = t_Transaction.ID );

      UPDATE Transactions.t_TransactionDetail
        SET Account = Company.f_AccountGetName(AccountID) ,
            DateOnly = DateIs ,
            DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
            DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
            Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
            CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(CurrencyID) ,
            BalanceF = Currencys.f_Format(CurrencyID, Balance) ,
            BalanceAR = Currencys.f_ToWordAR(Balance, CurrencyID, 1) ,
            BalanceEN = Currencys.f_ToWordEN(Balance, CurrencyID, 1)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @TransactionIDs AS s
                        WHERE s.ID = t_TransactionDetail.TransactionID );

    END;
     
    BEGIN --Fix t_Account GymSubscription

      UPDATE Company.t_Account
        SET GymSubscriptionC = Gym.f_GymSubscriptionGetCountByAccountID(ID) ,
            GymSubscriptionLast = [Gym].f_GymSubscriptionGetLastByAccountID(ID) ,
            GymSubscriptionTotal = [Gym].f_GymSubscriptionGetTotalByAccountID(ID) ,
            GymSubscriptionProfit = [Gym].f_GymSubscriptionGetProfitByAccountID(ID) ,
            GymSubscriptionActiveTo = [Gym].f_GymSubscriptionGetActiveToByAccountID(ID)
        WHERE ID IN ( @AccountID, @AccountIDOld );

      UPDATE Company.t_Account
        SET GymSubscriptionTotalF = Currencys.f_Format(CurrencyID, GymSubscriptionTotal) ,
            GymSubscriptionProfitF = Currencys.f_Format(CurrencyID, GymSubscriptionProfit) ,
            GymSubscriptionIsActive = IIF(GymSubscriptionActiveTo >= CONVERT(DATE, GETDATE()), 1, 0)
        WHERE ID IN ( @AccountID, @AccountIDOld );

    END;

    IF @SubscriptionTypeID <> @SubscriptionTypeIDOld
    BEGIN --Fix t_SubscriptionType

      UPDATE Gym.t_SubscriptionType
        SET NumberOfSubscriptions += 1
        WHERE ID = @SubscriptionTypeID;

      UPDATE Gym.t_SubscriptionType
        SET NumberOfSubscriptions -= 1
        WHERE ID = @SubscriptionTypeIDOld;

    END;

    IF @PersonalTrainerID <> @PersonalTrainerIDOld
    BEGIN --Fix t_PersonalTrainer

      UPDATE Gym.t_PersonalTrainer
        SET NumberOfSubscriptions += 1
        WHERE ID = @PersonalTrainerID;

      UPDATE Gym.t_PersonalTrainer
        SET NumberOfSubscriptions -= 1
        WHERE ID = @PersonalTrainerIDOld;

    END;

    BEGIN --Fix t_GymClass

      UPDATE Gym.t_GymClass
        SET NumberOfSubscriptions += ( SELECT COUNT(*)
                                        FROM @Classes AS s
                                        WHERE s.ClassID = t_GymClass.ID
                                     ) ,
            NumberOfActiveAccounts = Gym.f_GymClassGetNumberOfActiveAccounts(ID)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @Classes AS s
                        WHERE s.ClassID = t_GymClass.ID );

    END;
	
    BEGIN --Fix t_GymActiveVSAttendance
	
      EXECUTE Gym.s_GymActiveVSAttendanceMerge @DateIsOld, @ToDateOld, 1, 0; 
      EXECUTE Gym.s_GymActiveVSAttendanceMerge @DateIs, @ToDate, 1, 1; 
	  
    END;
	  
    BEGIN --Fix t_ProfitDaily

      SET @TotalDOld = 0 - @TotalDOld;
      SET @TotalLLOld = 0 - @TotalLLOld;
      SET @TotalEuroOld = 0 - @TotalEuroOld;

      EXECUTE Invoices.s_ProfitDailyGymSubscriptionMergePART @DateIsOld, @TotalDOld, @TotalLLOld, @TotalEuroOld; 
      EXECUTE Invoices.s_ProfitDailyGymSubscriptionMergePART @DateIs, @TotalD, @TotalLL, @TotalEuro; 
	  
    END;

    COMMIT TRANSACTION;

    SELECT 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT @return;

  END CATCH;

END;


GO

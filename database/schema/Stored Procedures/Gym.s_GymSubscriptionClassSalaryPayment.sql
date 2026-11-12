SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Gym].[s_GymSubscriptionClassSalaryPayment] @AccountBoxID UNIQUEIDENTIFIER ,
  @StatementIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
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

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @TransactionIDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          RefF NVARCHAR(MAX) NOT NULL
        );

      DECLARE @GymSubscriptionID UNIQUEIDENTIFIER ,
        @RefF NVARCHAR(MAX) ,
        @DateIs DATE ,
        @AccountID UNIQUEIDENTIFIER ,
        @Account NVARCHAR(MAX) ,
        @DoorID NVARCHAR(MAX) ,
        @SubscriptionType NVARCHAR(MAX) ,
        @AccountEmployeeID UNIQUEIDENTIFIER ,
        @AccountEmployee NVARCHAR(MAX) ,
        @AccountBox NVARCHAR(MAX) ,
        @Salary FLOAT ,
        @SalaryD FLOAT ,
        @UserIs NVARCHAR(MAX) ,
        @TrnID UNIQUEIDENTIFIER ,
        @TrnRef BIGINT ,
        @TrnStatementBase NVARCHAR(MAX) ,
        @TrnStatement NVARCHAR(MAX) ,
        @TrnRN INT ,
        @TrnLinkType TINYINT = 174 ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 ) @GymSubscriptionID = s.SubscriptionID ,
          @AccountEmployeeID = s.AccountEmployeeID ,
          @AccountEmployee = s.AccountEmployee ,
          @Salary = s.Salary ,
          @SalaryD = s.SalaryD
        FROM Gym.t_GymSubscriptionClass AS s
        WHERE s.ID = @ID;

      SELECT TOP ( 1 ) @RefF = s.RefF ,
          @AccountID = s.AccountID ,
          @Account = s.Account ,
          @SubscriptionType = s.SubscriptionType ,
          @CID = s.CurrencyID ,
          @E = s.ExchangeRate ,
          @ELL = s.ExchangeRateLL ,
          @EEuro = s.ExchangeRateEuro
        FROM Gym.t_GymSubscription AS s
        WHERE s.ID = @GymSubscriptionID;

      SET @DateIs = GETDATE();
	 
      SET @DoorID = FORMAT(Customers.f_CustomerGetIDDoorByAccount(@AccountID), 'n0');

      SET @AccountBox = Company.f_AccountGetName(@AccountBoxID);

      SET @UserIs = Users.f_UserGetName(@UserID);
       
      SET @TrnStatementBase = N'GS:' + @RefF + N' ' + @StatementIs;
		      
    END;
   
    BEGIN --Update

      SET @return = 0;

      UPDATE Gym.t_GymSubscriptionClass
        SET IsSalaryPaid = 1
        WHERE ID = @ID;
		
    END;

    BEGIN --Update t_GymSubscription

      SET @return = 0;

      UPDATE Gym.t_GymSubscription
        SET AreClassesSalariesPaid = IIF(( SELECT COUNT(*)
                                            FROM Gym.t_GymSubscriptionClass AS s
                                            WHERE s.SubscriptionID = @GymSubscriptionID AND s.IsSalaryPaid = 0 AND s.Salary > 0
                                         ) >= 1, 0, 1)
        WHERE ID = @GymSubscriptionID;
		
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
            @GymSubscriptionID ,
            @Event ,
            1 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    BEGIN --Transaction

      BEGIN --Set info

        SELECT @TrnRef = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = N'JV';

      END;

      BEGIN --Insert transaction

        SET @return = 0;

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
              @DateIs ,
              @TrnStatementBase ,
              @TrnLinkType ,
              @GymSubscriptionID ,
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

        SET @V = @Salary;
        SET @TrnRN = 1;   
        SET @TrnStatement = @DoorID + N' \ ' + @Account + N' \ ' + @SubscriptionType + N' \ ' + @TrnStatementBase;
        EXECUTE Transactions.s_TransactionDetailInsertDebit @TrnRN, @TrnID, @AccountEmployeeID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;
       
        SET @TrnRN += 1;
        SET @TrnStatement = @DoorID + N' \ ' + @AccountEmployee + N' \ ' + @SubscriptionType + N' \ ' + @TrnStatementBase;
        EXECUTE Transactions.s_TransactionDetailInsertCredit @TrnRN, @TrnID, @AccountBoxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;

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
            0 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          FROM @TransactionIDs AS s;

    END;

    BEGIN --Fix data

      UPDATE Company.t_Account
        SET StatusIs = 0 ,
            LastAction = GETDATE()
        WHERE ID IN ( @AccountEmployeeID, @AccountBoxID ) AND StatusIs = 1;
               
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
     
    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @return;

  END CATCH;

END;





GO

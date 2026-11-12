SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarExpenseUpdate]
  @DateIs DATE ,
  @BoxAccountID UNIQUEIDENTIFIER ,
  @CarExpenseAccountID UNIQUEIDENTIFIER ,
  @VendorAccountID UNIQUEIDENTIFIER ,
  @VendorTaxAccountID UNIQUEIDENTIFIER ,
  @PaymentMethod TINYINT ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @ExchangeRate DECIMAL(18, 2) ,
  @ExchangeRateLL DECIMAL(18, 2) ,
  @ExchangeRateEuro DECIMAL(18, 2) ,
  @TaxExchangeRateLL DECIMAL(18, 2) ,
  @TaxExchangeRateEuro DECIMAL(18, 2) ,
  @TaxExchangeRateEvent NVARCHAR(MAX) ,
  @Balance FLOAT ,
  @TaxRate DECIMAL(4, 2) ,
  @TaxValue FLOAT ,
  @NetIs FLOAT ,
  @TransactionDetailTypeIs TINYINT ,
  @ChequeNumber NVARCHAR(MAX) ,
  @ChequeImage IMAGE ,
  @ChequeNote NVARCHAR(MAX) ,
  @ChequeDateGet DATE ,
  @ChequeStopNotificationGet BIT ,
  @NotificationTextAR NVARCHAR(MAX) ,
  @NotificationTextEN NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @StatementIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventInsert NVARCHAR(MAX) ,
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

      DECLARE @CarID UNIQUEIDENTIFIER ,
        @BalanceDOld FLOAT ,
        @BalanceLLOld FLOAT ,
        @BalanceEuroOld FLOAT ,
        @TaxValueDOld FLOAT ,
        @TaxValueLLOld FLOAT ,
        @TaxValueEuroOld FLOAT ,
        @NetIsDOld FLOAT ,
        @NetIsLLOld FLOAT ,
        @NetIsEuroOld FLOAT ,
        @Ref BIGINT ,
        @TransactionRef BIGINT ,
        @TransactionID UNIQUEIDENTIFIER ,
        @RowNumber INT ,
        @BoxAccount NVARCHAR(MAX) ,
        @BoxAccountNumberF NVARCHAR(MAX) ,
        @CarExpenseAccount NVARCHAR(MAX) ,
        @CarExpenseAccountNumberF NVARCHAR(MAX) ,
        @VendorTaxAccount NVARCHAR(MAX) ,
        @Currency NVARCHAR(MAX) ,
        @CurrencyTypeIs INT ,
        @LinkType TINYINT = 182 ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @StatementIs_ NVARCHAR(MAX) ,
        @BalanceD FLOAT ,
        @TaxValueD FLOAT ,
        @NetIsD FLOAT ,
        @return INT;

    END;

    BEGIN --Set info

      SET @BoxAccount = Company.f_AccountGetName(@BoxAccountID);

      SET @BoxAccountNumberF = Company.f_AccountGetNumberF(@BoxAccountID);

      SET @CarExpenseAccount = Company.f_AccountGetName(@CarExpenseAccountID);

      SET @CarExpenseAccountNumberF = Company.f_AccountGetNumberF(@CarExpenseAccountID);

      SET @VendorTaxAccount = Company.f_AccountGetName(@VendorTaxAccountID);

      SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);

      SET @CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID);
      IF @CurrencyTypeIs <> 0
      BEGIN
	                              
        SET @TaxExchangeRateLL = @ExchangeRateLL;
        SET @TaxExchangeRateEuro = @ExchangeRateEuro;

      END;

      SET @CID = @CurrencyID;
      SET @E = @ExchangeRate;
      SET @ELL = @ExchangeRateLL;
      SET @EEuro = @ExchangeRateEuro;
	
      SET @BalanceD = @Balance / @ExchangeRate;

      SET @TaxValueD = @TaxValue / @ExchangeRate;

      SET @NetIsD = @NetIs / @ExchangeRate;

      SELECT TOP ( 1 )
              @CarID = s.CarID ,
              @Ref = s.Ref ,
              @BalanceDOld = s.BalanceD ,
              @BalanceLLOld = s.BalanceLL ,
              @BalanceEuroOld = s.BalanceEuro ,
              @TaxValueDOld = s.TaxValueD ,
              @TaxValueLLOld = s.TaxValueLL ,
              @TaxValueEuroOld = s.TaxValueEuro ,
              @NetIsDOld = s.NetIsD ,
              @NetIsLLOld = s.NetIsLL ,
              @NetIsEuroOld = s.NetIsEuro
      FROM    Cars.t_CarExpense AS s
      WHERE   s.ID = @ID;

      SELECT TOP ( 1 )
              @TransactionRef = s.Ref
      FROM    Transactions.t_Transaction AS s
      WHERE   s.LinkType = @LinkType
              AND s.LinkID = @ID
              AND s.TypeIs = N'JV'
      ORDER BY s.ID;

    END;

    BEGIN --Insert

      SET @return = 0;

      UPDATE  Cars.t_CarExpense
      SET     DateIs = @DateIs ,
              DateOnly = @DateIs ,
              DateMonthly = DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
              DateYearly = DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
              ByUserID = @UserID ,
              ByUser = Users.f_UserGetName(@UserID) ,
              FromAccountID = @BoxAccountID ,
              FromAccount = @BoxAccount ,
              FromAccountNumberF = @BoxAccountNumberF ,
              ToAccountID = @CarExpenseAccountID ,
              ToAccount = @CarExpenseAccount ,
              ToAccountNumberF = @CarExpenseAccountNumberF ,
              VendorAccountID = @VendorAccountID ,
              VendorAccount = Company.f_AccountGetName(@VendorAccountID) ,
              VendorAccountNumberF = Company.f_AccountGetNumberF(@VendorAccountID) ,
              PaymentMethod = @PaymentMethod ,
              CurrencyID = @CurrencyID ,
              Currency = @Currency ,
              ExchangeRate = @ExchangeRate ,
              ExchangeRateLL = @ExchangeRateLL ,
              ExchangeRateEuro = @ExchangeRateEuro ,
              TaxExchangeRateLL = @TaxExchangeRateLL ,
              TaxExchangeRateEuro = @TaxExchangeRateEuro ,
              Balance = @Balance ,
              BalanceF = Currencys.f_Format(@CurrencyID, @Balance) ,
              BalanceD = @BalanceD ,
              BalanceLL = @BalanceD * @ExchangeRateLL ,
              BalanceEuro = @BalanceD * @ExchangeRateEuro ,
              TaxRate = @TaxRate ,
              TaxRateF = Currencys.f_FormatRate(@TaxRate) ,
              TaxValue = @TaxValue ,
              TaxValueF = Currencys.f_Format(@CurrencyID, @TaxValue) ,
              TaxValueD = @TaxValueD ,
              TaxValueLL = @TaxValueD * @TaxExchangeRateLL ,
              TaxValueEuro = @TaxValueD * @TaxExchangeRateEuro ,
              NetIs = @NetIs ,
              NetIsF = Currencys.f_Format(@CurrencyID, @NetIs) ,
              NetIsD = @NetIsD ,
              NetIsLL = @NetIsD * @ExchangeRateLL ,
              NetIsEuro = @NetIsD * @ExchangeRateEuro ,
              NetIsAR = Currencys.f_ToWordAR(@NetIs, @CurrencyID, 1) ,
              NetIsEN = Currencys.f_ToWordEN(@NetIs, @CurrencyID, 1) ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

    END;
	
    BEGIN --Fix t_Car

      UPDATE  Cars.t_Car
      SET     TotalExpensesD += @NetIsD - @NetIsDOld ,
              TotalExpensesLL += ( @NetIsD * @ExchangeRateLL ) - @NetIsLLOld ,
              TotalExpensesEuro += ( @NetIsD * @ExchangeRateEuro ) - @NetIsEuroOld
      WHERE   ID = @CarID;

      UPDATE  Cars.t_Car
      SET     ProfitD = ProfitCarRentsD - TotalExpensesD ,
              ProfitLL = ProfitCarRentsLL - TotalExpensesLL ,
              ProfitEuro = ProfitCarRentsEuro - TotalExpensesEuro
      WHERE   ID = @CarID;

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT  INTO Cars.t_CarExpenseMoving
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
                1 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    BEGIN --Delete old transaction

      DELETE  FROM Transactions.t_Transaction
      WHERE   LinkType = @LinkType
              AND LinkID = @ID;

    END;

    BEGIN --Transaction

      IF @TransactionRef IS NULL
      BEGIN --Set info

        SELECT  @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
        FROM    Transactions.t_Transaction AS s
        WHERE   s.TypeIs = N'JV';

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE  FROM @IDs;

        INSERT  INTO Transactions.t_Transaction
                ( Ref ,
                  TypeIs ,
                  DateIs ,
                  DescriptionIs ,
                  LinkType ,
                  LinkID ,
                  UserID
                )
        OUTPUT  Inserted.ID
                INTO @IDs ( ID )
        VALUES  ( @TransactionRef ,
                  N'JV' ,
                  @DateIs ,
                  REPLACE(@StatementIs, N'{0}', @Ref) ,
                  @LinkType ,
                  @ID ,
                  @UserID
                );

        SET @TransactionID = ( SELECT TOP ( 1 )
                                      s.ID
                               FROM   @IDs AS s
                               ORDER BY s.ID
                             );

      END;
	  
      BEGIN --Insert detail

        IF @PaymentMethod = 1
        BEGIN
	                            
          SET @BoxAccountID = @VendorAccountID;

        END;

        SET @V = @Balance;
        SET @RowNumber = 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @BoxAccount;
        EXECUTE Transactions.s_TransactionDetailInsertDebitFull @RowNumber, @TransactionID, @CarExpenseAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro,
          @StatementIs_, @TransactionDetailTypeIs, @ChequeNumber, @ChequeImage, @ChequeNote, @ChequeDateGet, @ChequeStopNotificationGet, @NotificationTextAR,
          @NotificationTextEN;
	
        SET @RowNumber = 2;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @CarExpenseAccount;
        EXECUTE Transactions.s_TransactionDetailInsertCreditFull @RowNumber, @TransactionID, @BoxAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_,
          @TransactionDetailTypeIs, @ChequeNumber, @ChequeImage, @ChequeNote, @ChequeDateGet, @ChequeStopNotificationGet, @NotificationTextAR,
          @NotificationTextEN;
		
        IF @TaxValue > 0
        BEGIN --Insert detail tax

          SET @V = @TaxValue;
          SET @RowNumber = 3;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @BoxAccount + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL,
                                                                                                                                         N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertDebitTax @RowNumber, @TransactionID, @VendorTaxAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TaxValue,
            @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;

          SET @RowNumber = 3;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @VendorTaxAccount + N' (' + @TaxExchangeRateEvent + N': '
            + FORMAT(@TaxExchangeRateLL, N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertCreditTax @RowNumber, @TransactionID, @BoxAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TaxValue,
            @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;
		
        END;

      END;

      BEGIN --Insert event

        SET @return = -1;

        INSERT  INTO Transactions.t_TransactionMoving
                ( UserID ,
                  SectionID ,
                  EventIs ,
                  EventType ,
                  ComputerIP ,
                  Computer ,
                  ComputerAccount
                )
        VALUES  ( @UserID ,
                  @TransactionID ,
                  @EventInsert + CONVERT(NVARCHAR(MAX), @TransactionRef) ,
                  0 ,
                  @ComputerIP ,
                  @Computer ,
                  @ComputerAccount
                );

      END;

    END;
	
    BEGIN --Fix t_Transaction

      UPDATE  Transactions.t_Transaction
      SET     RefF = FORMAT(Ref, 'n0') ,
              DateOnly = DateIs ,
              DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
              DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
              AccountsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                      ', ' + t.Account AS [text()]
                                              FROM    Transactions.t_TransactionDetail AS t
                                              WHERE   t.TransactionID = @TransactionID
                                            FOR
                                              XML PATH('')
                                            )) ,
              BalanceD = COALESCE(( SELECT  SUM(s.Balance)
                                    FROM    Transactions.t_TransactionDetail AS s
                                    WHERE   s.TransactionID = t_Transaction.ID
                                            AND s.CurrencyTypeIs = 0
                                            AND s.Balance > 0
                                  ), 0) ,
              BalanceLL = COALESCE(( SELECT SUM(s.Balance)
                                     FROM   Transactions.t_TransactionDetail AS s
                                     WHERE  s.TransactionID = t_Transaction.ID
                                            AND s.CurrencyTypeIs = 1
                                            AND s.Balance > 0
                                   ), 0) ,
              BalanceEuro = COALESCE(( SELECT SUM(s.Balance)
                                       FROM   Transactions.t_TransactionDetail AS s
                                       WHERE  s.TransactionID = t_Transaction.ID
                                              AND s.CurrencyTypeIs = 2
                                              AND s.Balance > 0
                                     ), 0) ,
              UserIs = Users.f_UserGetName(UserID)
      WHERE   ID = @TransactionID;

    END;

    BEGIN --Update t_CarRentalStatistics
	
      UPDATE  Cars.t_CarRentalStatistics
      SET     ExpensesSubTotalD -= @BalanceDOld ,
              ExpensesSubTotalLL -= @BalanceLLOld ,
              ExpensesSubTotalEuro -= @BalanceEuroOld ,
              ExpensesTaxValueD -= @TaxValueDOld ,
              ExpensesTaxValueLL -= @TaxValueLLOld ,
              ExpensesTaxValueEuro -= @TaxValueEuroOld ,
              ExpensesTotalD -= @NetIsDOld ,
              ExpensesTotalLL -= @NetIsLLOld ,
              ExpensesTotalEuro -= @NetIsEuroOld;

      UPDATE  Cars.t_CarRentalStatistics
      SET     ExpensesSubTotalD += @BalanceD ,
              ExpensesSubTotalLL += @BalanceD * @ExchangeRateLL ,
              ExpensesSubTotalEuro += @BalanceD * @ExchangeRateEuro ,
              ExpensesTaxValueD += @TaxValueD ,
              ExpensesTaxValueLL += @TaxValueD * @TaxExchangeRateLL ,
              ExpensesTaxValueEuro += @TaxValueD * @TaxExchangeRateEuro ,
              ExpensesTotalD += @NetIsD ,
              ExpensesTotalLL += @NetIsD * @ExchangeRateLL ,
              ExpensesTotalEuro += @NetIsD * @ExchangeRateEuro;
  
      UPDATE  Cars.t_CarRentalStatistics
      SET     ProfitD = RentalsProfitD - ExpensesTotalD ,
              ProfitLL = RentalsProfitLL - ExpensesTotalLL ,
              ProfitEuro = RentalsProfitEuro - ExpensesTotalEuro;

    END;

    COMMIT TRANSACTION;

    RETURN  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN  @return;

  END CATCH;

END;










GO

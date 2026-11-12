SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_ExpenseInsert] @DateIs DATE ,
  @BoxAccountID UNIQUEIDENTIFIER ,
  @ExpenseAccountID UNIQUEIDENTIFIER ,
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

      DECLARE @Ref BIGINT ,
        @TransactionRef BIGINT ,
        @TransactionID UNIQUEIDENTIFIER ,
        @RowNumber INT ,
        @BoxAccount NVARCHAR(MAX) ,
        @BoxAccountNumberF NVARCHAR(MAX) ,
        @ExpenseAccount NVARCHAR(MAX) ,
        @ExpenseAccountNumberF NVARCHAR(MAX) ,
        @VendorAccount NVARCHAR(MAX) ,
        @VendorAccountNumberF NVARCHAR(MAX) ,
        @VendorTaxAccount NVARCHAR(MAX) ,
        @Currency NVARCHAR(MAX) ,
        @CurrencyTypeIs INT ,
        @LinkType TINYINT = 8 ,
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

      SELECT @Ref = COALESCE(MAX(s.Ref), 0) + 1
        FROM Company.t_Expense AS s;

      SET @BoxAccount = Company.f_AccountGetName(@BoxAccountID);

      SET @BoxAccountNumberF = Company.f_AccountGetNumberF(@BoxAccountID);

      SET @ExpenseAccount = Company.f_AccountGetName(@ExpenseAccountID);
      SET @ExpenseAccountNumberF = Company.f_AccountGetNumberF(@ExpenseAccountID);
     
	  SET @VendorAccount = Company.f_AccountGetName(@VendorAccountID);
      SET @VendorAccountNumberF = Company.f_AccountGetNumberF(@VendorAccountID);

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

    END;

    BEGIN --Insert

      SET @return = 0;

      INSERT INTO Company.t_Expense
          ( Ref ,
            RefF ,
            DateIs ,
            DateOnly ,
            DateMonthly ,
            DateYearly ,
            UserID ,
            UserIs ,
            FromAccountID ,
            FromAccount ,
            FromAccountNumberF ,
            ToAccountID ,
            ToAccount ,
            ToAccountNumberF ,
            VendorAccountID ,
            VendorAccount ,
            VendorAccountNumberF ,
            PaymentMethod ,
            CurrencyID ,
            Currency ,
            ExchangeRate ,
            ExchangeRateLL ,
            ExchangeRateEuro ,
            TaxExchangeRateLL ,
            TaxExchangeRateEuro ,
            Balance ,
            BalanceF ,
            BalanceD ,
            BalanceLL ,
            BalanceEuro ,
            TaxRate ,
            TaxRateF ,
            TaxValue ,
            TaxValueF ,
            TaxValueD ,
            TaxValueLL ,
            TaxValueEuro ,
            NetIs ,
            NetIsF ,
            NetIsD ,
            NetIsLL ,
            NetIsEuro ,
            NetIsAR ,
            NetIsEN ,
            DescriptionIs
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Ref ,
            FORMAT(@Ref, 'n0') ,
            @DateIs ,
            @DateIs ,
            DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
            DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
            @UserID ,
            Users.f_UserGetName(@UserID) ,
            @BoxAccountID ,
            @BoxAccount ,
            @BoxAccountNumberF ,
            @ExpenseAccountID ,
            @ExpenseAccount ,
            @ExpenseAccountNumberF ,
            @VendorAccountID ,
            @VendorAccount ,
            @VendorAccountNumberF ,
            @PaymentMethod ,
            @CurrencyID ,
            @Currency ,
            @ExchangeRate ,
            @ExchangeRateLL ,
            @ExchangeRateEuro ,
            @TaxExchangeRateLL ,
            @TaxExchangeRateEuro ,
            @Balance ,
            Currencys.f_Format(@CurrencyID, @Balance) ,
            @BalanceD ,
            @BalanceD * @ExchangeRateLL ,
            @BalanceD * @ExchangeRateEuro ,
            @TaxRate ,
            Currencys.f_FormatRate(@TaxRate) ,
            @TaxValue ,
            Currencys.f_Format(@CurrencyID, @TaxValue) ,
            @TaxValueD ,
            @TaxValueD * @TaxExchangeRateLL ,
            @TaxValueD * @TaxExchangeRateEuro ,
            @NetIs ,
            Currencys.f_Format(@CurrencyID, @NetIs) ,
            @NetIsD ,
            @NetIsD * @ExchangeRateLL ,
            @NetIsD * @ExchangeRateEuro ,
            Currencys.f_ToWordAR(@NetIs, @CurrencyID, 1) ,
            Currencys.f_ToWordEN(@NetIs, @CurrencyID, 1) ,
            @DescriptionIs
          );

      SET @ID = ( SELECT TOP ( 1 ) s.ID
                    FROM @IDs AS s
                    ORDER BY s.ID
                );

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Company.t_ExpenseMoving
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
            @Event + N': ' + CONVERT(NVARCHAR(MAX), @Ref) ,
            0 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    BEGIN --Transaction

      BEGIN --Set info

        SELECT @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = N'JV';

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
            ( @TransactionRef ,
              N'JV' ,
              @DateIs ,
              REPLACE(@StatementIs, N'{0}', @Ref) ,
              @LinkType ,
              @ID ,
              @UserID
            );

        SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                FROM @IDs AS s
                                ORDER BY s.ID
                             );

      END;
	  
      BEGIN --Insert detail

        SET @V = @Balance;
        SET @RowNumber = 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @VendorAccount;
        EXECUTE Transactions.s_TransactionDetailInsertDebitFull @RowNumber, @TransactionID, @ExpenseAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_, @TransactionDetailTypeIs, @ChequeNumber, @ChequeImage, @ChequeNote, @ChequeDateGet, @ChequeStopNotificationGet, @NotificationTextAR, @NotificationTextEN;
	
        SET @RowNumber += 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @ExpenseAccount;
        EXECUTE Transactions.s_TransactionDetailInsertCreditFull @RowNumber, @TransactionID, @VendorAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_, @TransactionDetailTypeIs, @ChequeNumber, @ChequeImage, @ChequeNote, @ChequeDateGet, @ChequeStopNotificationGet, @NotificationTextAR, @NotificationTextEN;
     
	    IF @PaymentMethod = 0
        BEGIN

	    SET @RowNumber += 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @BoxAccount;
        EXECUTE Transactions.s_TransactionDetailInsertDebitFull @RowNumber, @TransactionID, @VendorAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_, @TransactionDetailTypeIs, @ChequeNumber, @ChequeImage, @ChequeNote, @ChequeDateGet, @ChequeStopNotificationGet, @NotificationTextAR, @NotificationTextEN;
	
        SET @RowNumber += 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @VendorAccount;
        EXECUTE Transactions.s_TransactionDetailInsertCreditFull @RowNumber, @TransactionID, @BoxAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_, @TransactionDetailTypeIs, @ChequeNumber, @ChequeImage, @ChequeNote, @ChequeDateGet, @ChequeStopNotificationGet, @NotificationTextAR, @NotificationTextEN;

        END;	
			
        IF @TaxValue > 0
        BEGIN --Insert detail tax

          SET @V = @TaxValue;
          SET @RowNumber += 1;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @ExpenseAccount + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL, N'#,##0.##') + N')';
	      EXECUTE Transactions.s_TransactionDetailInsertDebitTax @RowNumber, @TransactionID, @VendorTaxAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TaxValue, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;
		  
          SET @RowNumber += 1;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @ExpenseAccount + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL, N'#,##0.##') + N')';
		  EXECUTE Transactions.s_TransactionDetailInsertCreditTax @RowNumber, @TransactionID, @VendorAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TaxValue, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;

	    IF @PaymentMethod = 0
        BEGIN

          SET @RowNumber += 1;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @BoxAccount + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL, N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertDebitTax @RowNumber, @TransactionID, @VendorAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TaxValue, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;

          SET @RowNumber += 1;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @VendorAccount + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL, N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertCreditTax @RowNumber, @TransactionID, @BoxAccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TaxValue, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;
		
        END;

        END;

      END;

      BEGIN --Insert event

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
          VALUES
            ( @UserID ,
              @TransactionID ,
              @Event + CONVERT(NVARCHAR(MAX), @TransactionRef) ,
              0 ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
            );

      END;

    END;
	
    BEGIN --Fix t_Transaction

      UPDATE Transactions.t_Transaction
        SET RefF = FORMAT(Ref, 'n0') ,
            DateOnly = DateIs ,
            DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
            DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
            AccountsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t.Account AS [text()]
                                              FROM Transactions.t_TransactionDetail AS t
                                              WHERE t.TransactionID = @TransactionID
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
        WHERE ID = @TransactionID;

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

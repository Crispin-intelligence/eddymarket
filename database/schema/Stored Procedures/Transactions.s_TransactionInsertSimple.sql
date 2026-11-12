SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Transactions].[s_TransactionInsertSimple] @TypeIs NVARCHAR(225) ,
  @DateIs DATETIME ,
  @DescriptionIs NVARCHAR(MAX) ,
  @LinkType TINYINT ,
  @LinkTypeSub TINYINT ,
  @LinkID UNIQUEIDENTIFIER ,
  @DebitID UNIQUEIDENTIFIER ,
  @CreditID UNIQUEIDENTIFIER ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @ExchangeRate DECIMAL(18, 2) ,
  @ExchangeRateLL DECIMAL(18, 2) ,
  @ExchangeRateEuro DECIMAL(18, 2) ,
  @Amount FLOAT ,
  @DetailTypeIs TINYINT ,
  @ChequeNumber NVARCHAR(MAX) ,
  @ChequeImage IMAGE ,
  @ChequeNote NVARCHAR(MAX) ,
  @ChequeDateGet DATE ,
  @ChequeStopNotificationGet BIT ,
  @NotificationTextAR NVARCHAR(MAX) ,
  @NotificationTextEN NVARCHAR(MAX) ,
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
        @Debit NVARCHAR(MAX) ,
        @Credit NVARCHAR(MAX) ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @VD FLOAT ,
        @return INT;

    END;

    BEGIN --Set info

      SELECT @Ref = ISNULL(MAX(s.Ref), 0) + 1
        FROM Transactions.t_Transaction AS s
        WHERE s.TypeIs = @TypeIs;

      SET @Debit = Company.f_AccountGetName(@DebitID);
      SET @Credit = Company.f_AccountGetName(@CreditID);

      SET @CID = @CurrencyID;
      SET @E = @ExchangeRate;
      SET @ELL = @ExchangeRateLL;
      SET @EEuro = @ExchangeRateEuro;
      SET @V = @Amount;
      SET @VD = @Amount / @E;

    END;

    BEGIN --Insert transaction

      SET @return = 0;

      INSERT INTO Transactions.t_Transaction
          ( Ref ,
            TypeIs ,
            DateIs ,
            DescriptionIs ,
            LinkType ,
            LinkTypeSub ,
            LinkID ,
            UserID,
			DetailsCount
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Ref ,
            @TypeIs ,
            @DateIs ,
            @DescriptionIs ,
            @LinkType ,
            @LinkTypeSub ,
            @LinkID ,
            @UserID,
			2
          );

      SET @ID = ( SELECT TOP ( 1 ) s.ID
                    FROM @IDs AS s
                    ORDER BY s.ID
                );

    END;

    BEGIN --Insert detail

      INSERT INTO Transactions.t_TransactionDetail
          ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro, Debit, DebitD, DebitLL, DebitEuro, StatementIs, TypeIs, ChequeNumber, ChequeImage, ChequeNote, ChequeDateGet, ChequeStopNotificationGet, NotificationTextAR, NotificationTextEN, CurrencyID, ExchangeRate )
        VALUES  ( 1, @ID, @DebitID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro, @DescriptionIs + ' \ ' + @Credit, @DetailTypeIs, @ChequeNumber, @ChequeImage, @ChequeNote, @ChequeDateGet, @ChequeStopNotificationGet, @NotificationTextAR, @NotificationTextEN, @CID, @E ),
                ( 2, @ID, @CreditID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @DescriptionIs + ' \ ' + @Debit, @DetailTypeIs, @ChequeNumber, @ChequeImage, @ChequeNote, @ChequeDateGet, @ChequeStopNotificationGet, @NotificationTextAR, @NotificationTextEN, @CID, @E );

    END;

    BEGIN --Fix data

      UPDATE Company.t_Account
        SET StatusIs = 0 ,
            LastAction = GETDATE()
        WHERE ID IN ( @DebitID, @CreditID ) AND StatusIs = 1;
      
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
        WHERE TransactionID = @ID;
           
      UPDATE Transactions.t_Transaction
        SET RefF = FORMAT(Ref, 'n0') ,
            DateOnly = DateIs ,
            DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
            DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
            AccountsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t.Account AS [text()]
                                              FROM Transactions.t_TransactionDetail AS t
                                              WHERE t.TransactionID = @ID
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
        WHERE ID = @ID;

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
            @ID ,
            @Event + FORMAT(@Ref, 'n0') ,
            0 ,
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

    RETURN @return;

  END CATCH;

END;


GO

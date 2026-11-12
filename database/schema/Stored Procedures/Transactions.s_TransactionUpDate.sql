SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Transactions].[s_TransactionUpDate] @TypeIs NVARCHAR(225) ,
  @DateIs DATETIME ,
  @DescriptionIs NVARCHAR(MAX) ,
  @DetailIs Transactions.dt_TransactionDetail READONLY ,
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

      DECLARE @Ref BIGINT ,
        @TypeIsOld NVARCHAR(225) ,
        @return INT;

    END;
 
    BEGIN --Declare

      SELECT TOP ( 1 ) @Ref = s.Ref ,
          @TypeIsOld = s.TypeIs
        FROM Transactions.t_Transaction AS s
        WHERE s.ID = @ID;

      IF @TypeIs <> @TypeIsOld
      BEGIN
    
        SELECT @Ref = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = @TypeIs;

      END;

    END;

    BEGIN --Update transaction

      SET @return = 0;

      UPDATE Transactions.t_Transaction
        SET Ref = @Ref ,
            RefF = FORMAT(@Ref, 'n0') ,
            TypeIs = @TypeIs ,
            DateIs = @DateIs ,
            DateOnly = @DateIs ,
            DateFirstDayInMonth = DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
            DateFirstDayInYear = DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
            DescriptionIs = @DescriptionIs ,
            AccountsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t1.Name AS [text()]
                                              FROM @DetailIs AS t
                                                LEFT JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
                                          FOR
                                            XML PATH('')
                                          )) ,
            UserID = @UserID ,
            UserIs = Users.f_UserGetName(@UserID),
			DetailsCount = (SELECT COUNT(*) FROM @DetailIs)
        WHERE ID = @ID;

    END;

    BEGIN --Reinsert detail

      DELETE FROM Transactions.t_TransactionDetail
        WHERE TransactionID = @ID;

      INSERT INTO Transactions.t_TransactionDetail
          ( RowNumber ,
            TransactionID ,
            AccountID ,
            Account ,
            DateIs ,
            DateOnly ,
            DateFirstDayInMonth ,
            DateFirstDayInYear ,
            Balance ,
            BalanceF ,
            BalanceD ,
            BalanceLL ,
            BalanceEuro ,
            BalanceAR ,
            BalanceEN ,
            Credit ,
            CreditD ,
            CreditLL ,
            CreditEuro ,
            Debit ,
            DebitD ,
            DebitLL ,
            DebitEuro ,
            StatementIs ,
            TypeIs ,
            ChequeNumber ,
            ChequeImage ,
            ChequeNote ,
            ChequeDateGet ,
            ChequeStopNotificationGet ,
            CurrencyID ,
            Currency ,
            CurrencyTypeIs ,
            ExchangeRate ,
            NotificationTextAR ,
            NotificationTextEN
          )
          SELECT o.RowNumber ,
              @ID ,
              o.AccountID ,
              o.Account ,
              o.DateIs ,
              o.DateOnly ,
              o.DateFirstDayInMonth ,
              o.DateFirstDayInYear ,
              o.Balance ,
              o.BalanceF ,
              o.BalanceD ,
              o.BalanceLL ,
              o.BalanceEuro ,
              o.BalanceAR ,
              o.BalanceEN ,
              ABS(o.Credit) ,
              ABS(IIF(o.BalanceD < 0, o.BalanceD, 0)) ,
              ABS(IIF(o.BalanceLL < 0, o.BalanceLL, 0)) ,
              ABS(IIF(o.BalanceEuro < 0, o.BalanceEuro, 0)) ,
              o.Debit ,
              IIF(o.BalanceD > 0, o.BalanceD, 0) ,
              IIF(o.BalanceLL > 0, o.BalanceLL, 0) ,
              IIF(o.BalanceEuro > 0, o.BalanceEuro, 0) ,
              o.StatementIs ,
              o.TypeIs ,
              o.ChequeNumber ,
              o.ChequeImage ,
              o.ChequeNote ,
              o.ChequeDateGet ,
              o.ChequeStopNotificationGet ,
              o.CurrencyID ,
              o.Currency ,
              o.CurrencyTypeIs ,
              o.ExchangeRate ,
              o.NotificationTextAR ,
              o.NotificationTextEN
            FROM ( SELECT t.RowNumber ,
                      t.AccountID ,
                      Company.f_AccountGetName(t.AccountID) AS Account ,
                      t.DateIs ,
                      t.DateIs AS DateOnly ,
                      DATEFROMPARTS(YEAR(t.DateIs), MONTH(t.DateIs), 1) AS DateFirstDayInMonth ,
                      DATEFROMPARTS(YEAR(t.DateIs), 1, 1) AS DateFirstDayInYear ,
                      t.Balance ,
                      Currencys.f_Format(t.CurrencyID, t.Balance) AS BalanceF ,
                      t.Balance / t.ExchangeRate AS BalanceD ,
                      Currencys.f_ExchangeToLL(t.CurrencyID, t.Balance, t.Balance / t.ExchangeRate) AS BalanceLL ,
                      Currencys.f_ExchangeToEuro(t.CurrencyID, t.Balance, t.Balance / t.ExchangeRate) AS BalanceEuro ,
                      Currencys.f_ToWordAR(Balance, CurrencyID, 1) AS BalanceAR ,
                      Currencys.f_ToWordEN(Balance, CurrencyID, 1) AS BalanceEN ,
                      IIF(Balance < 0, Balance, 0) AS Credit ,
                      IIF(Balance > 0, Balance, 0) AS Debit ,
                      t.StatementIs ,
                      t.TypeIs ,
                      t.ChequeNumber ,
                      t.ChequeImage ,
                      t.ChequeNote ,
                      t.ChequeDateGet ,
                      t.ChequeStopNotificationGet ,
                      t.CurrencyID ,
                      Currencys.f_CurrencyGetName(t.CurrencyID) AS Currency ,
                      Currencys.f_CurrencyGetTypeIs(t.CurrencyID) AS CurrencyTypeIs ,
                      t.ExchangeRate ,
                      t.NotificationTextAR ,
                      t.NotificationTextEN
                    FROM @DetailIs AS t
                 ) AS o
            ORDER BY o.RowNumber;

    END;

    BEGIN --Fix data

      UPDATE Company.t_Account
        SET StatusIs = 0 ,
            LastAction = GETDATE()
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @DetailIs AS s
                        WHERE s.AccountID = t_Account.ID ) AND StatusIs = 1;

    END;

    BEGIN --Fix data

      UPDATE Transactions.t_Transaction
        SET BalanceD = COALESCE(( SELECT SUM(s.Balance)
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
                                   ), 0)
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
            @Event ,
            @EventType ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

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

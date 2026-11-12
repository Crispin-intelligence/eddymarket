SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarRentalOwnerPaid]
  @DateIs DATE ,
  @AccountBoxID UNIQUEIDENTIFIER ,
  @AccountExpenseID UNIQUEIDENTIFIER ,
  @StatementIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @EventTypeTransaction TINYINT ,
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

      DECLARE @TrnIDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          RefF NVARCHAR(MAX) NOT NULL
        );

      DECLARE @CarRentalID UNIQUEIDENTIFIER ,
        @RefF NVARCHAR(MAX) ,
        @AccountBox NVARCHAR(MAX) ,
        @AccountExpense NVARCHAR(MAX) ,
        @Profit FLOAT ,
        @ProfitD FLOAT ,
        @ProfitLL FLOAT ,
        @ProfitEuro FLOAT ,
        @TrnID UNIQUEIDENTIFIER ,
        @TrnRef BIGINT ,
        @TrnRN INT ,
        @TrnStatementBase NVARCHAR(MAX) ,
        @TrnStatement NVARCHAR(MAX) ,
        @TrnLinkType TINYINT = 185 ,
        @TrnLinkTypeSub TINYINT = 11 ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @return INT;
		
    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @CarRentalID = s.CarRentalID ,
              @RefF = s1.RefF ,
              @Profit = s.Profit ,
              @ProfitD = s.ProfitD ,
              @ProfitLL = s.ProfitLL ,
              @ProfitEuro = s.ProfitEuro ,
              @CID = s1.CurrencyID ,
              @E = s1.ExchangeRate ,
              @ELL = s1.ExchangeRateLL ,
              @EEuro = s1.ExchangeRateEuro
      FROM    Cars.t_CarRentalOwner AS s
      INNER JOIN Cars.t_CarRental AS s1 ON s1.ID = s.CarRentalID
      WHERE   s.ID = @ID;
  
      SET @AccountBox = Company.f_AccountGetName(@AccountBoxID);
      SET @AccountExpense = Company.f_AccountGetName(@AccountExpenseID);
          
      SET @TrnStatementBase = N'CR:' + @RefF + N' ' + @StatementIs;
		      
    END;

    BEGIN --Update

      SET @return = 0;

      UPDATE  Cars.t_CarRentalOwner
      SET     Paid = 1
      WHERE   ID = @ID;
		
    END;

    BEGIN --Insert Event

      SET @return = -1;

      INSERT  INTO Cars.t_CarRentalMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @CarRentalID ,
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    BEGIN --Transaction

      BEGIN --Set info
      
        SET @return = 0;

        SELECT  @TrnRef = ISNULL(MAX(s.Ref), 0) + 1
        FROM    Transactions.t_Transaction AS s
        WHERE   s.TypeIs = N'JV';

      END;

      BEGIN --Insert transaction

        INSERT  INTO Transactions.t_Transaction
                ( Ref ,
                  TypeIs ,
                  DateIs ,
                  DescriptionIs ,
                  LinkType ,
                  LinkTypeSub ,
                  LinkID ,
                  SubLinkID ,
                  UserID
                )
        OUTPUT  Inserted.ID
                INTO @IDs ( ID )
        VALUES  ( @TrnRef ,
                  N'JV' ,
                  @DateIs ,
                  @TrnStatementBase ,
                  @TrnLinkType ,
                  @TrnLinkTypeSub ,
                  @CarRentalID ,
                  @ID ,
                  @UserID
                );

        SET @TrnID = ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDs AS s
                       ORDER BY s.ID
                     );

        INSERT  @TrnIDs
                ( ID, RefF )
        VALUES  ( @TrnID, FORMAT(@TrnRef, 'n0') );

      END;

      BEGIN --t_TransactionDetail

        SET @V = @Profit;
        SET @TrnRN = 1;
        SET @TrnStatement = @TrnStatementBase + ' \ ' + @AccountBox;
        EXECUTE Transactions.s_TransactionDetailInsertDebit @TrnRN, @TrnID, @AccountExpenseID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;
		
        SET @TrnRN += 1;
        SET @TrnStatement = @TrnStatementBase + ' \ ' + @AccountExpense;
        EXECUTE Transactions.s_TransactionDetailInsertCredit @TrnRN, @TrnID, @AccountBoxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;

      END;

    END;

    BEGIN --Insert t_TransactionMoving

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
      SELECT  @UserID ,
              @TrnID ,
              @Event + s.RefF ,
              @EventTypeTransaction ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @TrnIDs AS s;

    END;

    BEGIN --Fix data

      UPDATE  Company.t_Account
      SET     StatusIs = 0 ,
              LastAction = GETDATE()
      WHERE   ID IN ( @AccountBoxID, @AccountExpenseID )
              AND StatusIs = 1;
               
      UPDATE  Transactions.t_Transaction
      SET     RefF = FORMAT(Ref, 'n0') ,
              DateOnly = DateIs ,
              DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
              DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
              AccountsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                      ', ' + t.Account AS [text()]
                                              FROM    Transactions.t_TransactionDetail AS t
                                              WHERE   t.TransactionID = @TrnID
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
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @TrnIDs AS s
                       WHERE  s.ID = t_Transaction.ID );

      UPDATE  Transactions.t_TransactionDetail
      SET     Account = Company.f_AccountGetName(AccountID) ,
              DateOnly = DateIs ,
              DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
              DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
              Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
              CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(CurrencyID) ,
              BalanceF = Currencys.f_Format(CurrencyID, Balance) ,
              BalanceAR = Currencys.f_ToWordAR(Balance, CurrencyID, 1) ,
              BalanceEN = Currencys.f_ToWordEN(Balance, CurrencyID, 1)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @TrnIDs AS s
                       WHERE  s.ID = t_TransactionDetail.TransactionID );

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

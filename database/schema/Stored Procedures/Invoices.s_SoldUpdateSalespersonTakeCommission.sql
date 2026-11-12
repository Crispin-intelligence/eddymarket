SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_SoldUpdateSalespersonTakeCommission] @SalespersonTakeCommission BIT ,
  @DateIs DATE ,
  @BoxID UNIQUEIDENTIFIER ,
  @UserID UNIQUEIDENTIFIER ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @EventTransactionBase NVARCHAR(MAX) ,
  @IDAndEvent Alls.tt_IDAndEvent READONLY
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
          RefF NVARCHAR(MAX) NOT NULL ,
          AccountSalespersonID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @ID UNIQUEIDENTIFIER ,
        @RefF NVARCHAR(MAX) ,
        @AccountSalespersonID UNIQUEIDENTIFIER ,
        @Salesperson NVARCHAR(MAX) ,
        @Box NVARCHAR(MAX) ,
        @CommissionValue FLOAT ,
        @TransactionID UNIQUEIDENTIFIER ,
        @TransactionRef BIGINT ,
        @LinkType TINYINT = 2 ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @VD FLOAT ,
        @return INT;

    END;

    BEGIN --Set info

      SET @Box = Company.f_AccountGetName(@BoxID);
   
    END;

    BEGIN --Update 

      SET @return = 0;

      UPDATE Invoices.t_Sold
        SET SalespersonTakeCommission = @SalespersonTakeCommission, 
		CommissionAvailableValue = IIF(@SalespersonTakeCommission = 1, 0, IIF(CommissionRateType = 0, CommissionValue, IIF(StatusPayment = 0, 0, CommissionValue))), 
		CommissionAvailableValueD = IIF(@SalespersonTakeCommission = 1, 0, IIF(CommissionRateType = 0, CommissionValueD, IIF(StatusPayment = 0, 0, CommissionValueD))), 
		CommissionAvailableValueLL = IIF(@SalespersonTakeCommission = 1, 0, IIF(CommissionRateType = 0, CommissionValueLL, IIF(StatusPayment = 0, 0, CommissionValueLL))), 
		CommissionAvailableValueEuro = IIF(@SalespersonTakeCommission = 1, 0, IIF(CommissionRateType = 0, CommissionValueEuro, IIF(StatusPayment = 0, 0, CommissionValueEuro)))
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDAndEvent AS s
                        WHERE s.ID = t_Sold.ID );

      UPDATE Invoices.t_Sold
        SET CommissionAvailableValueF = Currencys.f_Format(CurrencyID, CommissionAvailableValue)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDAndEvent AS s
                        WHERE s.ID = t_Sold.ID );

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Invoices.t_SoldMoving ( UserID, SectionID, EventIs, EventType, ComputerIP, Computer, ComputerAccount )
          SELECT @UserID, s.ID, s.EventIs, 1, @ComputerIP, @Computer, @ComputerAccount
            FROM @IDAndEvent AS s;

    END;

    BEGIN --Delete t_Transaction

      DELETE FROM Transactions.t_Transaction
        WHERE TypeIs = N'JV' AND LinkTypeSub = 8 AND LinkType = 2 AND EXISTS ( SELECT s.ID
                                                                                FROM @IDAndEvent AS s
                                                                                WHERE s.ID = t_Transaction.LinkID );
		
    END;

    IF @SalespersonTakeCommission = 1
    BEGIN --Insert t_Transaction

      DECLARE i CURSOR FORWARD_ONLY
      FOR
      SELECT s.ID
        FROM @IDAndEvent AS s
          LEFT JOIN Invoices.t_Sold AS s1 ON s1.ID = s.ID
        WHERE s1.CommissionValue > 0;

      OPEN i;
      FETCH NEXT FROM i
    INTO @ID;
      WHILE @@FETCH_STATUS = 0
      BEGIN
	
        BEGIN --Get Info

          SELECT @RefF = s.RefF, @Salesperson = s.Salesperson, @AccountSalespersonID = Company.f_AccountSalespersonGetID(s.SalespersonID), @CommissionValue = s.CommissionValue, @CID = s.CurrencyID, @E = s.ExchangeRate, @ELL = s.ExchangeRateLL, @EEuro = s.ExchangeRateEuro
            FROM Invoices.t_Sold AS s
            WHERE s.ID = @ID;
   
        END;

        BEGIN --Set info

          SELECT  @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
            FROM Transactions.t_Transaction AS s
            WHERE s.TypeIs = N'JV';
   
        END;

        BEGIN --Insert t_Transaction

          DELETE FROM @IDs;

          INSERT INTO Transactions.t_Transaction ( Ref, TypeIs, DateIs, DescriptionIs, LinkType, LinkTypeSub, LinkID, UserID )
            OUTPUT Inserted.ID
              INTO @IDs ( ID )
            VALUES ( @TransactionRef, N'JV', @DateIs, N'S:Inv' + @RefF, @LinkType, 8, @ID, @UserID );
   
          SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                  FROM @IDs AS s
                                  ORDER BY s.ID
                               );

          INSERT @TransactionIDs ( ID, RefF, AccountSalespersonID )
            VALUES ( @TransactionID, FORMAT(@TransactionRef, 'n0'), @AccountSalespersonID );

        END;

        BEGIN --Insert detail
		
          SET @V = @CommissionValue;
          SET @VD = @CommissionValue / @E;

          INSERT INTO Transactions.t_TransactionDetail ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro, Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
            VALUES  ( 1, @TransactionID, @AccountSalespersonID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro, N'S:Inv' + @RefF + N' \ ' + @Box, @CID, @E ),
                    ( 2, @TransactionID, @BoxID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, N'S:Inv' + @RefF + N' \ ' + @Salesperson, @CID, @E );

        END;

        FETCH NEXT FROM i
        INTO @ID;
      END;
      CLOSE i;
      DEALLOCATE i;

    END;

    BEGIN --Insert t_TransactionMoving

      SET @return = -1;

      INSERT INTO Transactions.t_TransactionMoving ( UserID, SectionID, EventIs, EventType, ComputerIP, Computer, ComputerAccount )
          SELECT @UserID, s.ID, @EventTransactionBase + s.RefF, 0, @ComputerIP, @Computer, @ComputerAccount
            FROM @TransactionIDs AS s;

    END;

    BEGIN --Fix data
	
      UPDATE Company.t_Account
        SET StatusIs = 0, LastAction = GETDATE()
        WHERE ID IN ( @BoxID ) AND StatusIs = 1;
    
      UPDATE Company.t_Account
        SET StatusIs = 0, LastAction = GETDATE()
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @TransactionIDs AS s
                        WHERE s.AccountSalespersonID = t_Account.ID ) AND StatusIs = 1;
                
      UPDATE Transactions.t_Transaction
        SET RefF = FORMAT(Ref, 'n0'), DateOnly = DateIs, DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1), DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1), AccountsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t.Account AS [text()]
                                                                                                                                                                                                                        FROM Transactions.t_TransactionDetail AS t
                                                                                                                                                                                                                        WHERE t.TransactionID = @TransactionID
                                                                                                                                                                                                                    FOR
                                                                                                                                                                                                                      XML PATH('')
                                                                                                                                                                                                                    )), BalanceD = COALESCE(( SELECT SUM(s.Balance)
                                                                                                                                                                                                                                                FROM Transactions.t_TransactionDetail AS s
                                                                                                                                                                                                                                                WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 0 AND s.Balance > 0
                                                                                                                                                                                                                                            ), 0), BalanceLL = COALESCE(( SELECT SUM(s.Balance)
                                                                                                                                                                                                                                                                            FROM Transactions.t_TransactionDetail AS s
                                                                                                                                                                                                                                                                            WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 1 AND s.Balance > 0
                                                                                                                                                                                                                                                                        ), 0), BalanceEuro = COALESCE(( SELECT SUM(s.Balance)
                                                                                                                                                                                                                                                                                                          FROM Transactions.t_TransactionDetail AS s
                                                                                                                                                                                                                                                                                                          WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 2 AND s.Balance > 0
                                                                                                                                                                                                                                                                                                      ), 0), UserIs = Users.f_UserGetName(UserID)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @TransactionIDs AS s
                        WHERE s.ID = t_Transaction.ID );

      UPDATE Transactions.t_TransactionDetail
        SET Account = Company.f_AccountGetName(AccountID), DateOnly = DateIs, DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1), DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1), Currency = Currencys.f_CurrencyGetName(CurrencyID), CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(CurrencyID), BalanceF = Currencys.f_Format(CurrencyID, Balance), BalanceAR = Currencys.f_ToWordAR(Balance, CurrencyID, 1), BalanceEN = Currencys.f_ToWordEN(Balance, CurrencyID, 1)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @TransactionIDs AS s
                        WHERE s.ID = t_TransactionDetail.TransactionID );

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

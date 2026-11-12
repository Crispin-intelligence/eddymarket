SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Transactions].[s_TransactionRebuildingStatistics]
    @UserID UNIQUEIDENTIFIER ,
    @Event NVARCHAR(MAX) ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX)
AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            BEGIN --Declare

                DECLARE @Return INT;

            END;

            BEGIN; --Rebuilding statistics

                DISABLE TRIGGER Transactions.tr_Transaction ON Transactions.t_Transaction;

                DISABLE TRIGGER Transactions.tr_TransactionDetail ON Transactions.t_TransactionDetail;

                UPDATE  Transactions.t_TransactionDetail
                SET     Account = Company.f_AccountGetName(AccountID) ,
                        BalanceF = Currencys.f_Format(CurrencyID, Balance) ,
                        BalanceAR = Currencys.f_ToWordAR(Balance, CurrencyID,
                                                         1) ,
                        BalanceEN = Currencys.f_ToWordEN(Balance, CurrencyID,
                                                         1) ,
                        Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
                        CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(CurrencyID);

                UPDATE  Transactions.t_Transaction
                SET     RefF = FORMAT(Ref, 'n0') ,
                        UserIs = Users.f_UserGetName(UserID) ,
                        BalanceD = COALESCE(( SELECT    SUM(s.Balance)
                                              FROM      Transactions.t_TransactionDetail
                                                        AS s
                                              WHERE     s.TransactionID = t_Transaction.ID
                                                        AND s.CurrencyTypeIs = 0
                                                        AND s.Balance > 0
                                            ), 0) ,
                        BalanceLL = COALESCE(( SELECT   SUM(s.Balance)
                                               FROM     Transactions.t_TransactionDetail
                                                        AS s
                                               WHERE    s.TransactionID = t_Transaction.ID
                                                        AND s.CurrencyTypeIs = 1
                                                        AND s.Balance > 0
                                             ), 0) ,
                        BalanceEuro = COALESCE(( SELECT SUM(s.Balance)
                                                 FROM   Transactions.t_TransactionDetail
                                                        AS s
                                                 WHERE  s.TransactionID = t_Transaction.ID
                                                        AND s.CurrencyTypeIs = 2
                                                        AND s.Balance > 0
                                               ), 0) ,
                        AccountsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                              ', ' + t1.Name AS [text()]
                                                        FROM  Transactions.t_TransactionDetail
                                                              AS t
                                                              LEFT JOIN Company.t_Account
                                                              AS t1 ON t1.ID = t.AccountID
                                                        WHERE t.TransactionID = t_Transaction.ID
                                                      FOR
                                                        XML PATH('')
                                                      )) ,
                        DetailsCount = ( SELECT COUNT(*)
                                         FROM   Transactions.t_TransactionDetail
                                                AS s
                                         WHERE  s.TransactionID = t_Transaction.ID
                                       );

                UPDATE  Transactions.t_Transaction
                SET     BalanceDF = Currencys.f_FormatD(BalanceD) ,
                        BalanceLLF = Currencys.f_FormatLL(BalanceLL) ,
                        BalanceEuroF = Currencys.f_FormatEuro(BalanceEuro);

                ENABLE TRIGGER Transactions.tr_Transaction ON Transactions.t_Transaction;

                ENABLE TRIGGER Transactions.tr_TransactionDetail ON Transactions.t_TransactionDetail;

            END;

            BEGIN --Rebuilding statistics Transaction Detail By Day

                TRUNCATE TABLE Transactions.t_TransactionDetailByDay;

                INSERT  Transactions.t_TransactionDetailByDay
                        ( AccountID ,
                          Account ,
                          DateOnly ,
                          BalanceD ,
                          BalanceLL ,
                          BalanceEuro ,
                          CreditD ,
                          CreditLL ,
                          CreditEuro ,
                          DebitD ,
                          DebitLL ,
                          DebitEuro
                        )
                        SELECT  MIN(t.AccountID) AS AccountID ,
                                MIN(t.Account) AS Account ,
                                t.DateOnly ,
                                SUM(t.BalanceD) AS BalanceD ,
                                SUM(t.BalanceLL) AS BalanceLL ,
                                SUM(t.BalanceEuro) AS BalanceEuro ,
                                SUM(t.CreditD) AS CreditD ,
                                SUM(t.CreditLL) AS CreditLL ,
                                SUM(t.CreditEuro) AS CreditEuro ,
                                SUM(t.DebitD) AS DebitD ,
                                SUM(t.DebitLL) AS DebitLL ,
                                SUM(t.DebitEuro) AS DebitEuro
                        FROM    Transactions.t_TransactionDetail AS t
                        GROUP BY t.DateOnly ,
                                t.AccountID;

            END;

            BEGIN --Rebuilding statistics Transaction Detail By Month

                TRUNCATE TABLE Transactions.t_TransactionDetailByMonth;

                INSERT  Transactions.t_TransactionDetailByMonth
                        ( AccountID ,
                          Account ,
                          DateOnly ,
                          BalanceD ,
                          BalanceLL ,
                          BalanceEuro ,
                          CreditD ,
                          CreditLL ,
                          CreditEuro ,
                          DebitD ,
                          DebitLL ,
                          DebitEuro
                        )
                        SELECT  MIN(t.AccountID) AS AccountID ,
                                MIN(t.Account) AS Account ,
                                t.DateFirstDayInMonth ,
                                SUM(t.BalanceD) AS BalanceD ,
                                SUM(t.BalanceLL) AS BalanceLL ,
                                SUM(t.BalanceEuro) AS BalanceEuro ,
                                SUM(t.CreditD) AS CreditD ,
                                SUM(t.CreditLL) AS CreditLL ,
                                SUM(t.CreditEuro) AS CreditEuro ,
                                SUM(t.DebitD) AS DebitD ,
                                SUM(t.DebitLL) AS DebitLL ,
                                SUM(t.DebitEuro) AS DebitEuro
                        FROM    Transactions.t_TransactionDetail AS t
                        GROUP BY t.DateFirstDayInMonth ,
                                t.AccountID;

            END;

            BEGIN --Rebuilding statistics Transaction Detail By Year

                TRUNCATE TABLE Transactions.t_TransactionDetailByYear;

                INSERT  Transactions.t_TransactionDetailByYear
                        ( AccountID ,
                          Account ,
                          DateOnly ,
                          BalanceD ,
                          BalanceLL ,
                          BalanceEuro ,
                          CreditD ,
                          CreditLL ,
                          CreditEuro ,
                          DebitD ,
                          DebitLL ,
                          DebitEuro
                        )
                        SELECT  MIN(t.AccountID) AS AccountID ,
                                MIN(t.Account) AS Account ,
                                t.DateFirstDayInYear ,
                                SUM(t.BalanceD) AS BalanceD ,
                                SUM(t.BalanceLL) AS BalanceLL ,
                                SUM(t.BalanceEuro) AS BalanceEuro ,
                                SUM(t.CreditD) AS CreditD ,
                                SUM(t.CreditLL) AS CreditLL ,
                                SUM(t.CreditEuro) AS CreditEuro ,
                                SUM(t.DebitD) AS DebitD ,
                                SUM(t.DebitLL) AS DebitLL ,
                                SUM(t.DebitEuro) AS DebitEuro
                        FROM    Transactions.t_TransactionDetail AS t
                        GROUP BY t.DateFirstDayInYear ,
                                t.AccountID;

            END;

            BEGIN --Insert event

                SET @Return = -1;

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
                          '00000000-0000-0000-0000-000000000000' ,
                          @Event ,
                          6 ,
                          @ComputerIP ,
                          @Computer ,
                          @ComputerAccount
                        );

            END;

            COMMIT TRAN;

            RETURN 1;

        END TRY
        BEGIN CATCH

            ROLLBACK;

            RETURN @Return;

        END CATCH;

    END;








GO

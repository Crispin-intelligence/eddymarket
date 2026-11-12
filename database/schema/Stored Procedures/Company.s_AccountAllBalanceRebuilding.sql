SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_AccountAllBalanceRebuilding]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    DISABLE TRIGGER Company.tr_Account ON Company.t_Account;
    DISABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
    DISABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
    DISABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;
	 
    BEGIN --Rebuilding

      SET @Return = 0;

      UPDATE Company.t_Account
        SET BalanceD = ( SELECT COALESCE(SUM(s.BalanceD), 0)
                          FROM Transactions.t_TransactionDetail AS s
                          WHERE s.AccountID = t_Account.ID
                       ) ,
            BalanceLL = ( SELECT COALESCE(SUM(s.BalanceLL), 0)
                            FROM Transactions.t_TransactionDetail AS s
                            WHERE s.AccountID = t_Account.ID
                        ) ,
            BalanceEuro = ( SELECT COALESCE(SUM(s.BalanceEuro), 0)
                              FROM Transactions.t_TransactionDetail AS s
                              WHERE s.AccountID = t_Account.ID
                          );

      UPDATE Company.t_Account
        SET Balance = CASE CurrencyTypeIs
                        WHEN 0 THEN BalanceD
                        WHEN 1 THEN BalanceLL
                        ELSE BalanceEuro
                      END;

      UPDATE Company.t_Account
        SET BalanceF = Currencys.f_Format(CurrencyID, Balance);

      UPDATE Company.t_AccountLevel3
        SET BalanceD = ( SELECT COALESCE(SUM(s.BalanceD), 0)
                          FROM Company.t_Account AS s
                          WHERE s.Level3ID = t_AccountLevel3.ID
                       ) ,
            BalanceLL = ( SELECT COALESCE(SUM(s.BalanceLL), 0)
                            FROM Company.t_Account AS s
                            WHERE s.Level3ID = t_AccountLevel3.ID
                        ) ,
            BalanceEuro = ( SELECT COALESCE(SUM(s.BalanceEuro), 0)
                              FROM Company.t_Account AS s
                              WHERE s.Level3ID = t_AccountLevel3.ID
                          );

      UPDATE Company.t_AccountLevel2
        SET BalanceD = ( SELECT COALESCE(SUM(s.BalanceD), 0)
                          FROM Company.t_AccountLevel3 AS s
                          WHERE s.Level2ID = t_AccountLevel2.ID
                       ) ,
            BalanceLL = ( SELECT COALESCE(SUM(s.BalanceLL), 0)
                            FROM Company.t_AccountLevel3 AS s
                            WHERE s.Level2ID = t_AccountLevel2.ID
                        ) ,
            BalanceEuro = ( SELECT COALESCE(SUM(s.BalanceEuro), 0)
                              FROM Company.t_AccountLevel3 AS s
                              WHERE s.Level2ID = t_AccountLevel2.ID
                          );

      UPDATE Company.t_AccountLevel1
        SET BalanceD = ( SELECT COALESCE(SUM(s.BalanceD), 0)
                          FROM Company.t_AccountLevel2 AS s
                          WHERE s.Level1ID = t_AccountLevel1.ID
                       ) ,
            BalanceLL = ( SELECT COALESCE(SUM(s.BalanceLL), 0)
                            FROM Company.t_AccountLevel2 AS s
                            WHERE s.Level1ID = t_AccountLevel1.ID
                        ) ,
            BalanceEuro = ( SELECT COALESCE(SUM(s.BalanceEuro), 0)
                              FROM Company.t_AccountLevel2 AS s
                              WHERE s.Level1ID = t_AccountLevel1.ID
                          );



    END;

    ENABLE TRIGGER Company.tr_Account ON Company.t_Account;
    ENABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
    ENABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
    ENABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;
	

    COMMIT TRAN;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ENABLE TRIGGER Company.tr_Account ON Company.t_Account;
    ENABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
    ENABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
    ENABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;
	
    ROLLBACK;

    RETURN @Return;

  END CATCH;
END;








GO

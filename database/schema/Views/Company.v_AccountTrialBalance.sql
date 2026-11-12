SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountTrialBalance]
AS
    SELECT  t.ID ,
            t.Level3ID ,
            t1.Level2ID ,
            t2.Level1ID ,
            t.NumberF ,
            t.Name ,
            t.BalanceD ,
            t.BalanceLL ,
            t.BalanceEuro,
			t.Currency
    FROM    Company.t_Account AS t
            LEFT JOIN Company.t_AccountLevel3 AS t1 ON t1.ID = t.Level3ID
            LEFT JOIN Company.t_AccountLevel2 AS t2 ON t2.ID = t1.Level2ID;
	





GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_AccountLevel123TrialBalance]
AS
SELECT t.ID,
       t.ID AS Level1ID,
       '00000000-0000-0000-0000-000000000000' AS Level2ID,
       '00000000-0000-0000-0000-000000000000' AS Level3ID,
       1 AS LevelIs,
       t.NumberF,
       t.Name,
       t.BalanceD,
       t.BalanceLL,
       t.BalanceEuro
FROM Company.t_AccountLevel1 AS t
UNION
SELECT t.ID,
       t.Level1ID,
       t.ID AS Level2ID,
       '00000000-0000-0000-0000-000000000000' AS Level3ID,
       2 AS LevelIs,
       t.NumberF,
       t.Name,
       t.BalanceD,
       t.BalanceLL,
       t.BalanceEuro
FROM Company.t_AccountLevel2 AS t
UNION
SELECT t.ID,
       t1.Level1ID,
       t.Level2ID,
       t.ID AS Level3ID,
       3 AS LevelIs,
       t.NumberF,
       t.Name,
       t.BalanceD,
       t.BalanceLL,
       t.BalanceEuro
FROM Company.t_AccountLevel3 AS t
    LEFT JOIN Company.t_AccountLevel2 AS t1
        ON t1.ID = t.Level2ID;





GO

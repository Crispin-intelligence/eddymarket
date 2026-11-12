SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_AccountLevel3NotSync]
AS
SELECT  t.ID ,
        t.Level2ID ,
        t.Level2 ,
        t.NumberIs ,
        t.NumberF ,
        t.NumberNet ,
        t.Name ,
        t.BalanceD ,
        t.BalanceLL ,
        t.BalanceEuro ,
        t.DescriptionIs ,
        t.SearchText ,
        t.DateCreate
FROM    Company.t_AccountLevel3 AS t
WHERE   t.IsSync = 0;



GO

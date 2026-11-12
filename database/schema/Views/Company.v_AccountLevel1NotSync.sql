SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_AccountLevel1NotSync]
AS
SELECT  t.ID ,
        t.NumberIs ,
        t.NumberF ,
        t.Name ,
        t.BalanceD ,
        t.BalanceLL ,
        t.BalanceEuro ,
        t.DescriptionIs ,
        t.SearchText ,
        t.DateCreate
FROM    Company.t_AccountLevel1 AS t
WHERE   t.IsSync = 0;



GO

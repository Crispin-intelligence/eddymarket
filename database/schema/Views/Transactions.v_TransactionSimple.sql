SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Transactions].[v_TransactionSimple]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t.TypeIs ,
        t.BalanceType ,
        t.DateIs ,
        t.DateOnly ,
        t.DateFirstDayInMonth ,
        t.DateFirstDayInYear ,
        t.UserID ,
        t.UserIs ,
        t.DescriptionIs ,
        t.LinkType ,
        t.LinkTypeSub ,
        t.LinkID ,
        t.SubLinkID ,
        t.BalanceD ,
        t.BalanceDF ,
        t.BalanceLL ,
        t.BalanceLLF ,
        t.BalanceEuro ,
        t.BalanceEuroF ,
        t.AccountsNames ,
        t.DateCreate ,
        t.DetailsCount
FROM    Transactions.t_Transaction AS t
WHERE   t.LinkType = 69
        AND t.DetailsCount = 2;



GO

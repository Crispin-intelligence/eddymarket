SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Company].[v_OpenBox]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateIs,
       t.DateOnly,
       t.DateMonthly,
       t.DateYearly,
       t.UserID,
       t.UserIs,
       t.FromAccountID,
       t.FromAccount,
       t.FromAccountNumberF,
       t.ToAccountID,
       t.ToAccount,
       t.ToAccountNumberF,
       t.CurrencyID,
       t.Currency,
       t.ExchangeRate,
       t.Balance,
       t.BalanceF,
       t.BalanceD,
       t.BalanceLL,
       t.BalanceEuro,
       t.BalanceAR,
       t.BalanceEN,
       t.DescriptionIs,
       t.DateCreate
FROM Company.t_OpenBox AS t;







GO

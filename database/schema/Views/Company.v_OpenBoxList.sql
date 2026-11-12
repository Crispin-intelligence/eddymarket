SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Company].[v_OpenBoxList]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateIs,
       t.UserIs,
       t.FromAccount,
       t.FromAccountNumberF,
       t.ToAccount,
       t.ToAccountNumberF,
       t.Currency,
       t.ExchangeRate,
       t.BalanceF,
       t.BalanceD,
       t.BalanceLL,
       t.BalanceEuro,
       t.DescriptionIs,
       t.DateCreate
FROM Company.t_OpenBox AS t;








GO

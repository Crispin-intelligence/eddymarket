SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_CloseBoxNotSync]
AS
SELECT t.ID ,
    t.Ref ,
    t.RefF ,
    t.DateIs ,
    t.DateOnly ,
    t.FromUserID ,
    t.FromUser ,
    t.ToUserID ,
    t.ToUser ,
    t.FromAccountID ,
    t.FromAccount ,
    t.FromAccountNumberF ,
    t.ToAccountID ,
    t.ToAccount ,
    t.ToAccountNumberF ,
    t.CurrencyID ,
    t.Currency ,
    t.ExchangeRate ,
    t.Balance ,
    t.BalanceF ,
    t.BalanceD ,
    t.BalanceLL ,
    t.BalanceEuro ,
    t.BalanceAR ,
    t.BalanceEN ,
    t.BalanceDifference ,
    t.BalanceDifferenceF ,
    t.BalanceDifferenceD ,
    t.TotalD ,
    t.TotalDF ,
    t.TotalLL ,
    t.TotalLLF ,
    t.TotalEuro ,
    t.TotalEuroF ,
    t.DescriptionIs ,
    t.DateCreate ,
    t.IsSync
  FROM Company.t_CloseBox AS t
  WHERE t.IsSync = 0;
  


GO

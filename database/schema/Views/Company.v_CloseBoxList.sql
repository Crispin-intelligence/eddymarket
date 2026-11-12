SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Company].[v_CloseBoxList]
AS
SELECT t.ID ,
    t.Ref ,
    t.RefF ,
    t.DateIs ,
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
    t.Currency ,
    t.ExchangeRate ,
    t.BalanceF ,
    t.BalanceD ,
    t.BalanceLL ,
    t.BalanceEuro ,
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
  FROM Company.t_CloseBox AS t;






GO

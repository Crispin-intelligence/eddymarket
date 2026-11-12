SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_CloseBoxDetailList]
AS
SELECT t.ID ,
    t.CloseBoxID ,
    t1.Ref ,
    t1.RefF ,
    t1.DateIs ,
    t1.FromAccountID ,
    t1.FromAccount ,
    t1.FromAccountNumberF ,
    t1.ToAccountID ,
    t1.ToAccount ,
    t1.ToAccountNumberF ,
    t.CurrencyID ,
    t.Currency ,
    t.Price ,
    t.PriceF ,
    t.PriceD ,
    t.Qty ,
    t.Total ,
    t.TotalF ,
    t.DescriptionIs ,
    t.DateCreate ,
    t.IsSync
  FROM Company.t_CloseBoxDetail AS t
  LEFT JOIN Company.t_CloseBox AS t1 ON t1.ID = t.CloseBoxID;









GO

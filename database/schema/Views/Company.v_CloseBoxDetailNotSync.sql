SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_CloseBoxDetailNotSync]
AS
SELECT t.ID ,
    t.CloseBoxID ,
    t.CurrencyID ,
    t.Currency ,
    t.CurrencyTypeIs ,
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
  WHERE t.IsSync = 0;




GO

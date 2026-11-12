SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Cars].[v_CarExpensesFillReport]
AS
SELECT  t.ID ,
        t.RefF ,
        t.DateIs ,
        t.Car ,
        t.FromAccount ,
        t.ToAccount ,
        t1.TypeIs AS CurrencyTypeIs ,
        t.NetIsF ,
        t.NetIsD ,
        t.NetIsLL ,
        t.NetIsEuro 
FROM    Cars.t_CarExpense AS t
INNER JOIN Currencys.t_Currency AS t1 ON t1.ID = t.CurrencyID










GO

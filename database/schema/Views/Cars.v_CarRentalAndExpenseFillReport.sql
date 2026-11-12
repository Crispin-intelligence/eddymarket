SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarRentalAndExpenseFillReport]
AS
SELECT  t.ID ,
        t.RefF ,
        t.PaperRef ,
        t.Account ,
        t.Car ,
        t.AgreementDate ,
        t1.TypeIs AS CurrencyTypeIs ,
        t.TotalF ,
        t.TotalD ,
        t.TotalLL ,
        t.TotalEuro ,
        0 AS Operation
FROM    Cars.t_CarRental AS t
INNER JOIN Currencys.t_Currency AS t1 ON t1.ID = t.CurrencyID
UNION ALL
SELECT  t.ID ,
        t.RefF ,
        t.PaperRef ,
        t.Account ,
        t.Car ,
        t.AgreementDate ,
        t1.TypeIs AS CurrencyTypeIs ,
        t.TotalF ,
        t.TotalD ,
        t.TotalLL ,
        t.TotalEuro ,
        0 AS Operation
FROM    Cars.t_CarRentalHistory AS t
INNER JOIN Currencys.t_Currency AS t1 ON t1.ID = t.CurrencyID
WHERE   t.StatusIs <> 3
UNION ALL
SELECT  t.ID ,
        t.RefF ,
        N'' AS PaperRef ,
        t.ToAccount ,
        t.Car ,
        t.DateIs ,
        t1.TypeIs AS CurrencyTypeIs ,
        t.NetIsF ,
        t.NetIsD ,
        t.NetIsLL ,
        t.NetIsEuro ,
        1 AS Operation
FROM    Cars.t_CarExpense AS t
INNER JOIN Currencys.t_Currency AS t1 ON t1.ID = t.CurrencyID




;




GO

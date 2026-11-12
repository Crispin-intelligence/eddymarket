SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarRentalOpenAndClosedAgreementFillReport]
AS
SELECT  t.ID ,
        t.RefF ,
        t.PaperRef ,
        t.Account ,
        COALESCE(t2.Phones, '') AS Phones ,
        t.Car ,
        t.AgreementDate ,
        t.FromDate ,
        t.ToDate ,
        t3.TypeIs AS CurrencyTypeIs ,
        t.TotalF ,
        t.TotalD ,
        t.TotalLL ,
        t.TotalEuro ,
        t.StatusIs
FROM    Cars.t_CarRental AS t
INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
LEFT JOIN Alls.v_Person AS t2 ON t2.ID = t1.LinkWithID
INNER JOIN Currencys.t_Currency AS t3 ON t3.ID = t.CurrencyID
UNION ALL
SELECT  t.ID ,
        t.RefF ,
        t.PaperRef ,
        t.Account ,
        COALESCE(t2.Phones, '') AS Phones ,
        t.Car ,
        t.AgreementDate ,
        t.FromDate ,
        t.ToDate ,
        t3.TypeIs AS CurrencyTypeIs ,
        t.TotalF ,
        t.TotalD ,
        t.TotalLL ,
        t.TotalEuro ,
        t.StatusIs
FROM    Cars.t_CarRentalHistory AS t
INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
LEFT JOIN Alls.v_Person AS t2 ON t2.ID = t1.LinkWithID
INNER JOIN Currencys.t_Currency AS t3 ON t3.ID = t.CurrencyID
WHERE   t.StatusIs <> 3;








GO

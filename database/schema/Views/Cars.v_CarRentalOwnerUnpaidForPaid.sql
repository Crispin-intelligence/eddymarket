SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Cars].[v_CarRentalOwnerUnpaidForPaid]
AS
SELECT  t.ID ,
        t.CarRentalID ,
        t1.RefF ,
        t1.CurrencyID ,
        t1.Currency ,
        t3.TypeIs AS CurrencyTypeIs ,
        t.OwnerProfileID ,
        t.OwnerProfile ,
        t2.ID AS AccountID ,
        t.Profit ,
        t.ProfitF ,
        t.ProfitD ,
        t.ProfitLL ,
        t.ProfitEuro
FROM    Cars.t_CarRentalOwner AS t
INNER JOIN Cars.t_CarRental AS t1 ON t1.ID = t.CarRentalID
INNER JOIN Company.t_Account AS t2 ON t2.SectionID = 179
                                      AND t2.LinkWithID = t.OwnerProfileID
INNER JOIN Currencys.t_Currency AS t3 ON t3.ID = t1.CurrencyID
WHERE   t.Paid = 0;







GO

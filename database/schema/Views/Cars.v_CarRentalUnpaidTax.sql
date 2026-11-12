SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Cars].[v_CarRentalUnpaidTax]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t1.TypeIs AS CurrencyTypeIs ,
        t.TaxRate ,
        t.TotalTaxF ,
        t.TotalTaxD ,
        t.TotalTaxLL ,
        t.TotalTaxEuro
FROM    Cars.t_CarRental AS t
INNER JOIN Currencys.t_Currency AS t1 ON t1.ID = t.CurrencyID
WHERE   t.TotalTax > 0 AND t.PaidTax = 0;




GO

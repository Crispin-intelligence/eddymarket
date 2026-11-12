SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarRentalCustomersCarsRentalsFillReport]
AS
SELECT  t.ID ,
        t.RefF ,
        t.PaperRef ,
        t.AccountID ,
        t.Account ,
        t.Car ,
        t.AgreementDate ,
        t1.TypeIs AS CurrencyTypeIs ,
        t.TotalF ,
        t.TotalD ,
        t.TotalLL ,
        t.TotalEuro ,
        t.CheckOutDate ,
        t.CheckInDate ,
        t.DurationF
FROM    Cars.t_CarRental AS t
INNER JOIN Currencys.t_Currency AS t1 ON t1.ID = t.CurrencyID
WHERE   t.StatusIs <> 3
UNION ALL
SELECT  t.ID ,
        t.RefF ,
        t.PaperRef ,
        t.AccountID ,
        t.Account ,
        t.Car ,
        t.AgreementDate ,
        t1.TypeIs AS CurrencyTypeIs ,
        t.TotalF ,
        t.TotalD ,
        t.TotalLL ,
        t.TotalEuro ,
        t.CheckOutDate ,
        t.CheckInDate ,
        t.DurationF
FROM    Cars.t_CarRentalHistory AS t
INNER JOIN Currencys.t_Currency AS t1 ON t1.ID = t.CurrencyID
WHERE   t.StatusIs <> 3;



GO

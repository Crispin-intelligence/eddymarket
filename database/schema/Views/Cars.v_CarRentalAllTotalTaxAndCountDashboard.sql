SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Cars].[v_CarRentalAllTotalTaxAndCountDashboard]
AS
SELECT  t.ID ,
        t.Account ,
        t.Car ,
        t.AgreementDate ,
        t.TotalTaxD ,
        t.TotalTaxLL ,
        t.TotalTaxEuro
FROM    Cars.t_CarRental AS t
UNION ALL
SELECT  t.ID ,
        t.Account ,
        t.Car ,
        t.AgreementDate ,
        t.TotalTaxD ,
        t.TotalTaxLL ,
        t.TotalTaxEuro
FROM    Cars.t_CarRentalHistory AS t
WHERE   t.StatusIs <> 3;



GO

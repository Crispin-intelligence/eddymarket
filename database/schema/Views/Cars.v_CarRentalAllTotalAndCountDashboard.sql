SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarRentalAllTotalAndCountDashboard]
AS
SELECT  t.ID ,
        t.Account ,
        t.Car ,
        t.AgreementDate ,
        t.TotalD ,
        t.TotalLL ,
        t.TotalEuro
FROM    Cars.t_CarRental AS t
UNION ALL
SELECT  t.ID ,
        t.Account ,
        t.Car ,
        t.AgreementDate ,
        t.TotalD ,
        t.TotalLL ,
        t.TotalEuro
FROM    Cars.t_CarRentalHistory AS t
WHERE t.StatusIs <> 3;


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarRentalOwnerList]
AS
SELECT  t.ID ,
        t.CarRentalID ,
        t1.Ref ,
        t1.RefF ,
        t1.CarID ,
        t1.AgreementDate ,
        t.OwnerProfileID ,
        t.OwnerProfile ,
        t2.CarsCount ,
        t2.CarRentalCount ,
        t2.TotalProfitD ,
        t2.TotalProfitLL ,
        t2.TotalProfitEuro ,
        t.ProfitRatio ,
        t.Profit ,
        t.ProfitF ,
        t.ProfitD ,
        t.ProfitLL ,
        t.ProfitEuro ,
        t.Paid ,
        t.DateCreate ,
        t.IsSync
FROM    Cars.t_CarRentalOwner AS t
INNER JOIN Cars.t_CarRental AS t1 ON t1.ID = t.CarRentalID
INNER JOIN Cars.t_CarOwnersProfile AS t2 ON t2.ID = t.OwnerProfileID;






GO

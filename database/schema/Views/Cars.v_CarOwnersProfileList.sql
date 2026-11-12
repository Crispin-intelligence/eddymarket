SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [Cars].[v_CarOwnersProfileList]
AS
SELECT  t.ID ,
        t.Name ,
        t1.NumberF ,
        t1.BalanceF ,
        t1.BalanceD ,
        t.DescriptionIs ,
        t.CarsCount ,
        t.CarRentalCount ,
        t.TotalProfitD ,
        t.TotalProfitLL ,
        t.TotalProfitEuro ,
        t.CarRentalUnpaidCount ,
        t.UnpaidTotalProfitD ,
        t.UnpaidTotalProfitLL ,
        t.UnpaidTotalProfitEuro ,
        t.DateCreate ,
        t.IsSync
FROM    Cars.t_CarOwnersProfile AS t
INNER JOIN Company.t_Account AS t1 ON t1.SectionID = 179
                                      AND t1.LinkWithID = t.ID;









GO

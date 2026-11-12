SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Cars].[v_CarOwnersProfileNotSync]
AS
SELECT  t.ID ,
        t.Name ,
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
        t.SearchText ,
        t.DateCreate
FROM    Cars.t_CarOwnersProfile AS t
WHERE   t.IsSync = 0;









GO

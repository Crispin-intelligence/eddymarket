SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarRentalMustOutInToday]
AS
SELECT  t.ID ,
        t.Account ,
        t.Car ,
        t1.ImageIs ,
        t.FromDate ,
        t.ToDate ,
        t.FromDate AS DateBase ,
        t.TotalF ,
        IIF(t.Rest = 0, N'', t.RestF) AS RestF ,
        t.StatusIs
FROM    Cars.t_CarRental AS t
INNER JOIN Cars.t_Car AS t1 ON t1.ID = t.CarID
WHERE   t.StatusIs = 0
UNION ALL
SELECT  t.ID ,
        t.Account ,
        t.Car ,
        t1.ImageIs ,
        t.FromDate ,
        t.ToDate ,
        t.ToDate AS DateBase ,
        t.TotalF ,
        IIF(t.Rest = 0, N'', t.RestF) AS RestF ,
        t.StatusIs
FROM    Cars.t_CarRental AS t
INNER JOIN Cars.t_Car AS t1 ON t1.ID = t.CarID
WHERE   t.StatusIs = 1;




GO

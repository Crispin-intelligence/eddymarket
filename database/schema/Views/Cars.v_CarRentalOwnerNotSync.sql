SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarRentalOwnerNotSync]
AS
SELECT  t.ID ,
        t.CarRentalID ,
        t.OwnerProfileID ,
        t.OwnerProfile ,
        t.ProfitRatio ,
        t.Profit ,
        t.ProfitF ,
        t.ProfitD ,
        t.ProfitLL ,
        t.ProfitEuro ,
        t.Paid ,
        t.SearchText ,
        t.DateCreate
FROM    Cars.t_CarRentalOwner AS t
WHERE   t.IsSync = 0;





GO

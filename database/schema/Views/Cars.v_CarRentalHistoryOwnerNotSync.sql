SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarRentalHistoryOwnerNotSync]
AS
SELECT  t.ID ,
        t.CarRentalHistoryID ,
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
FROM    Cars.t_CarRentalHistoryOwner AS t
WHERE   t.IsSync = 0;






GO

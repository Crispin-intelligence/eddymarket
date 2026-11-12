SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarOwners]
AS
SELECT t.ID ,
       t.CarID ,
       t.Car ,
       t.OwnerProfileID ,
       t.OwnerProfile ,
       t.ProfitRatio ,
       t.SearchText ,
       t.DateCreate ,
       t.IsSync
FROM Cars.t_CarOwners AS t;






GO

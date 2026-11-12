SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Cars].[v_CarOwnersNotSync]
AS
SELECT t.ID ,
       t.CarID ,
       t.Car ,
       t.OwnerProfileID ,
       t.OwnerProfile ,
       t.ProfitRatio ,
       t.SearchText ,
       t.DateCreate
  FROM Cars.t_CarOwners AS t
  WHERE t.IsSync = 0;
  



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Cars].[v_CarModelNotSync]
AS
SELECT t.ID ,
       t.Name ,
       t.CarMakeID ,
       t.CarMake ,
       t.DescriptionIs ,
       t.CarsCount ,
       t.AvailableCarsCount ,
       t.UnavailableCarsCount ,
       t.SearchText ,
       t.DateCreate
  FROM Cars.t_CarModel AS t
  WHERE t.IsSync = 0;









GO

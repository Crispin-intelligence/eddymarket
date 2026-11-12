SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Cars].[v_CarModel]
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
       t.DateCreate ,
       t.IsSync
FROM Cars.t_CarModel AS t;







GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Cars].[v_CarMakeNotSync]
AS
SELECT t.ID ,
       t.Name ,
       t.DescriptionIs ,
       t.ModelsCount ,
       t.CarsCount ,
       t.AvailableCarsCount ,
       t.UnavailableCarsCount ,
       t.SearchText ,
       t.DateCreate
  FROM Cars.t_CarMake AS t
  WHERE t.IsSync = 0;








GO

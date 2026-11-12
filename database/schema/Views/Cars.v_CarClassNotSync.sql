SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarClassNotSync]
AS
SELECT t.ID ,
       t.Name ,
       t.DescriptionIs ,
       t.CarsCount ,
       t.AvailableCarsCount ,
       t.UnavailableCarsCount ,
       t.SearchText ,
       t.DateCreate
  FROM Cars.t_CarClass AS t
  WHERE t.IsSync = 0;







GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarClass]
AS
SELECT t.ID ,
       t.Name ,
       t.DescriptionIs ,
       t.CarsCount ,
       t.AvailableCarsCount ,
       t.UnavailableCarsCount ,
       t.SearchText ,
       t.DateCreate ,
       t.IsSync
FROM Cars.t_CarClass AS t;





GO

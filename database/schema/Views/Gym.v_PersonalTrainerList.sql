SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Gym].[v_PersonalTrainerList]
AS
SELECT t.ID ,
       t.Name ,
       t.NameF ,
       t.Currency ,
       t.PriceF ,
       t.PriceD ,
       t.PriceLL ,
       t.PriceEuro ,
       t.SessionIs ,
       t.TotalF ,
       t.TotalD ,
       t.TotalLL ,
       t.TotalEuro ,
       t.AccountEmployeeID ,
       t.AccountEmployee ,
       t.AccountEmployeeNumber ,
       t.SalaryPercent ,
       t.SalaryF ,
       t.SalaryD ,
       t.SalaryLL ,
       t.SalaryEuro ,
       t.DescriptionIs ,
       t.IsEnabled ,
       t.DateCreate ,
       t.NumberOfSubscriptions ,
       t.IsSync 
  FROM Gym.t_PersonalTrainer AS t;









GO

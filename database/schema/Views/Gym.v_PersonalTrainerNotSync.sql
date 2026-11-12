SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Gym].[v_PersonalTrainerNotSync]
AS
SELECT t.ID ,
       t.Name ,
       t.NameF ,
       t.CurrencyID ,
       t.Currency ,
       t.Price ,
       t.PriceF ,
       t.PriceD ,
       t.PriceLL ,
       t.PriceEuro ,
       t.SessionIs ,
       t.Total ,
       t.TotalF ,
       t.TotalD ,
       t.TotalLL ,
       t.TotalEuro ,
       t.AccountEmployeeID ,
       t.AccountEmployee ,
       t.AccountEmployeeNumber ,
       t.SalaryPercent ,
       t.Salary ,
       t.SalaryF ,
       t.SalaryD ,
       t.SalaryLL ,
       t.SalaryEuro ,
       t.DescriptionIs ,
       t.IsEnabled ,
       t.DateCreate ,
       t.NumberOfSubscriptions
  FROM Gym.t_PersonalTrainer AS t
  WHERE t.IsSync = 0;









GO

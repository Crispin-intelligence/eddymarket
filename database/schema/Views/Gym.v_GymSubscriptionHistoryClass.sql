SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Gym].[v_GymSubscriptionHistoryClass]
AS
SELECT t.ID ,
    t.SubscriptionID ,
    t.ClassID ,
    t.ClassName ,
    t.AccountEmployeeID ,
    t.AccountEmployee ,
    t.AccountEmployeeNumber ,
    t.Price ,
    t.PriceF ,
    t.PriceD ,
    t.PriceLL ,
    t.PriceEuro ,
    t.SalaryPercent ,
    t.Salary ,
    t.SalaryF ,
    t.SalaryD ,
    t.SalaryLL ,
    t.SalaryEuro ,
    t.IsSalaryPaid ,
    t.DescriptionIs ,
    t.DateCreate ,
    t.IsSync ,
    1 AS InHistory
  FROM Gym.t_GymSubscriptionHistoryClass AS t;




GO

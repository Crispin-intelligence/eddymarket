SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Gym].[v_GymSubscriptionDeletedClassList]
AS
SELECT t.ID ,
    t.SubscriptionID ,
    t1.Ref ,
    t1.RefF ,
    t1.DateIs ,
    t1.ToDate ,
    t1.IsActive ,
    t1.AccountID ,
    t1.Account ,
    t3.ImageThumbnail ,
    t2.GymSubscriptionIsActive + 0 AS GymSubscriptionIsActive ,
    COALESCE(t3.IDDoor, -1) AS IDDoor ,
    t1.PaymentMethod ,
    t.ClassID ,
    t.ClassName ,
    t.AccountEmployeeID ,
    t.AccountEmployee ,
    t.AccountEmployeeNumber ,
    t.PriceF ,
    t.PriceD ,
    t.PriceLL ,
    t.PriceEuro ,
    t.SalaryPercent ,
    t.SalaryF ,
    t.SalaryD ,
    t.SalaryLL ,
    t.SalaryEuro ,
    t.IsSalaryPaid ,
    t.IsSalaryPaid + 0 AS IsSalaryPaid_ ,
    t.DescriptionIs ,
    t.DateCreate ,
    t.IsSync
  FROM Gym.t_GymSubscriptionDeletedClass AS t
  INNER JOIN Gym.t_GymSubscriptionDeleted AS t1 ON t1.ID = t.SubscriptionID
  INNER JOIN Company.t_Account AS t2 ON t2.ID = t1.AccountID
  LEFT JOIN Customers.t_Customer AS t3 ON t3.ID = t2.LinkWithID;

  



GO

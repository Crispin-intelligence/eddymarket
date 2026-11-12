SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_EmployeeChoose]
AS
SELECT t.ID ,
    t.Name ,
    t1.ShowInGymClass ,
    t1.ShowInPersonalTrainer ,
    t.Phones ,
    t.SocialMedia ,
    t.AddressIs ,
    t.DescriptionIs
  FROM Employees.t_Employee AS t
  LEFT OUTER JOIN Company.t_Account AS t1 ON t.ID = t1.LinkWithID AND t1.SectionID = 33 AND t1.NumberIs BETWEEN 4210100000 AND 4219999999;



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Employees].[v_SalesPersonListBlocked]
AS
SELECT  t.ID ,
        t.Name ,
        t1.Name AS Account ,
        t1.NumberF ,
        t1.Balance ,
        t1.BalanceF ,
        t.Phones ,
        t.SocialMedia ,
        t.AddressIs ,
        t.CommissionRate ,
        t.CommissionRateF ,
        t.CommissionRateType ,
        t.CommissionRateOn ,
        t.DescriptionIs ,
        t.StatusIs ,
        t.WhyThisStatus ,
        t.DateCreate
FROM    Employees.t_SalesPerson AS t
        LEFT OUTER JOIN Company.t_Account AS t1 ON t.ID = t1.LinkWithID
                                                   AND t1.SectionID = 149
                                                   AND t1.NumberIs BETWEEN 4610100000 AND 4610199999
WHERE   t.StatusIs = 2;







GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountChooseCustomerNotBlocked]
AS
SELECT  t.ID ,
        t.Name ,
        t.NumberF ,
        t.ShowInGymClass ,
        t.ShowInPersonalTrainer ,
        FORMAT(t1.IDDoor, N'0') AS IDDoor ,
        t1.Phones ,
        t1.AddressIs
FROM    Company.t_Account AS t
LEFT JOIN Customers.t_Customer AS t1 ON t1.ID = t.LinkWithID
                                        AND t.SectionID = 15
                                        AND t.IsMasterLink = 1
WHERE   t.NumberIs BETWEEN 4110100000 AND 4119999999
        AND t.StatusIs <> 2;




GO

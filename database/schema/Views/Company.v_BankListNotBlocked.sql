SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_BankListNotBlocked]
AS
SELECT  t.ID ,
        t.Name ,
        t1.ID AS AccountID ,
        t1.Name AS Account ,
        t1.NumberF ,
        t1.Currency AS AccountCurrency ,
        t1.Balance ,
        t1.BalanceD ,
        t1.BalanceF ,
        t1.LimitD ,
        t1.LimitF ,
        t.Phones ,
        t.PhonesC ,
        t.SocialMedia ,
        t.SocialMediaC ,
        t.StatesIs ,
        t.RegionIs ,
        t.Street ,
        t.Building ,
        t.FloorIs ,
        t.PostalCode ,
        t.AddressNote ,
        t.AddressIs ,
        t.DescriptionIs ,
        t.StatusIs ,
        t.WhyThisStatus ,
        t.DateCreate ,
        t.IsSync
FROM    Company.t_Bank AS t
INNER JOIN Company.t_Account AS t1 ON t.ID = t1.LinkWithID
                                      AND t1.SectionID = 38
WHERE   t.StatusIs <> 2;








GO

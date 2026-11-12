SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Employees].[v_SalesPersonListNotBlocked]
AS
SELECT  t.ID ,
        t.Name ,
        t1.ID AS AccountID ,
        t1.Name AS Account ,
        t1.NumberF ,
        t1.Balance ,
        t1.BalanceF ,
        t1.CurrencyTypeIs ,
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
        t.CommissionRate ,
        t.CommissionRateF ,
        t.CommissionRateType ,
        t.CommissionRateOn ,
        t.CommissionAvailableValueD ,
        t.CommissionAvailableValueLL ,
        t.CommissionAvailableValueEuro ,
        t.DescriptionIs ,
        t.CustomerC ,
        t.QuotationC ,
        t.InvoicesC ,
        t.FileStorageC ,
        t.StatusIs ,
        t.WhyThisStatus ,
        t.DateCreate ,
        t.IsSync
FROM    Employees.t_SalesPerson AS t
INNER JOIN Company.t_Account AS t1 ON t.ID = t1.LinkWithID
                                      AND t1.SectionID = 149
                                      AND t1.NumberIs BETWEEN 4610100000 AND 4610199999
WHERE   t.StatusIs <> 2;


GO

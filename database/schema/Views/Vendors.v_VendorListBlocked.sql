SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Vendors].[v_VendorListBlocked]
AS
SELECT  t.ID ,
        t.Name ,
        t1.Name AS Account ,
        t1.NumberF ,
        t1.BalanceF ,
        t.Phones ,
        t.SocialMedia ,
        t.Title ,
        t.Classification ,
        t.AddressIs ,
        t.NumberCurrency ,
        t.CallAfter ,
        t.CallAfterF ,
        t.DescriptionIs ,
        t.WhyThisStatus ,
        t.DateCreate
FROM    Vendors.t_Vendor AS t
INNER  JOIN Company.t_Account AS t1 ON t1.SectionID = 67
                                       AND t1.IsMasterLink = 1
                                       AND t1.LinkWithID = t.ID
WHERE   t.StatusIs = 2;






GO

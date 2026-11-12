SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Customers].[v_CustomerListBlocked]
AS
SELECT t.ID,
       t.Name,
       t1.Name AS Account,
       t1.NumberF,
       t1.BalanceF,
       t.Phones,
       t.SocialMedia,
       t.Title,
       t.Classification,
       t.SalesPerson,
       t.AddressIs,
       t.NumberCurrency,
       t.CallAfter,
       t.CallAfterF,
       t.DescriptionIs,
       t.WhyThisStatus,
       t.DateCreate
FROM Customers.t_Customer AS t
    LEFT OUTER JOIN Company.t_Account AS t1
        ON t1.LinkWithID = t.ID 
           AND t1.IsMasterLink = 1
           AND t1.SectionID = 15
WHERE t.StatusIs = 2;




GO

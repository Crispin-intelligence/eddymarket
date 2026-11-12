SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Customers].[v_CustomerAccountChoose]
AS
SELECT t.ID,
       t.Name,
	   t1.ID AS AccountID,
       t1.NumberF,
       t.Phones,
       t.AddressIs,
	   t.InternetPackage,
	   t.ActiveToInternet
FROM Customers.t_Customer AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.SectionID = 15
           AND t1.IsMasterLink = 1
           AND t1.LinkWithID = t.ID;






GO

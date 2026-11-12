SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Vendors].[v_VendorAccountChoose]
AS
SELECT t.ID,
       t.Name,
	   t1.ID AS AccountID,
       t1.NumberF,
       t.Phones,
       t.AddressIs
FROM Vendors.t_Vendor AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.SectionID = 67
           AND t1.IsMasterLink = 1
           AND t1.LinkWithID = t.ID;




GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Invoices].[v_SoldReportAddressAndClassificationDistinctClassification]
AS
SELECT DISTINCT
       t2.Classification
FROM Invoices.t_Sold AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.AccountCustomerID
    LEFT JOIN Alls.v_Person1 AS t2
        ON t2.ID = t1.LinkWithID;



GO

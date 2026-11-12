SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_FileStorageLinkedSumByType]
AS
SELECT t1.TypeIsID,
       SUM(t1.LinkC) AS LinkC,
       SUM(t1.LinkItemC) AS LinkItemC,
       SUM(t1.LinkCustomerC) AS LinkCustomerC,
       SUM(t1.LinkEmployeeC) AS LinkEmployeeC,
       SUM(t1.LinkVendorC) AS LinkVendorC,
       SUM(t1.LinkSalesPersonC) AS LinkSalesPersonC
FROM Company.t_FileStorageLinked AS t
    LEFT OUTER JOIN Company.t_FileStorage AS t1
        ON t.FileStorageID = t1.ID
GROUP BY t1.TypeIsID;



GO

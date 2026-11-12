SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Customers].[v_CustomerGroupDetailCurrentByCustomer]
AS
SELECT  t.ID ,
        t.CustomerGroupID ,
        t1.Name AS CustomerGroup ,
        t.CustomerID ,
        t.DateCreate
FROM    Customers.t_CustomerGroupDetail AS t
        LEFT JOIN Customers.t_CustomerGroup AS t1 ON t1.ID = t.CustomerGroupID;


GO

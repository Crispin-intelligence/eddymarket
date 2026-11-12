SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Customers].[v_CustomerGroupDetail]
AS
SELECT  t.ID ,
        t.CustomerGroupID ,
        t.CustomerID ,
        t.Customer ,
        t.DateCreate ,
        t.IsSync 
FROM    Customers.t_CustomerGroupDetail AS t;


GO

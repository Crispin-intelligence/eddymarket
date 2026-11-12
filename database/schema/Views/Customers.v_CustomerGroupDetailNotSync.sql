SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Customers].[v_CustomerGroupDetailNotSync]
AS
SELECT t.ID ,
       t.CustomerGroupID ,
       t.CustomerID ,
       t.Customer ,
       t.DateCreate ,
       t.IsSync 
FROM Customers.t_CustomerGroupDetail AS t
WHERE t.IsSync = 0;



GO

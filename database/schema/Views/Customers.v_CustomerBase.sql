SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create VIEW [Customers].[v_CustomerBase]
AS
SELECT t.ID,
       t.Name
FROM Customers.t_Customer AS t;


GO

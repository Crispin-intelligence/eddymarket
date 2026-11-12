SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Customers].[v_InternetPackageBase]
AS
SELECT t.ID,
       t.Name,
	   t.DateCreate
FROM Customers.t_InternetPackage AS t;



GO

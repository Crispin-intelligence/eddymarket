SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create VIEW [Customers].[v_ClassificationBase]
AS
SELECT t.ID,
       t.Name
FROM Customers.t_Classification AS t;


GO

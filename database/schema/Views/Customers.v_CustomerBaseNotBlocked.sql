SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Customers].[v_CustomerBaseNotBlocked]
AS
SELECT t.ID,
       t.Name
FROM Customers.t_Customer AS t
WHERE t.StatusIs <> 2;




GO

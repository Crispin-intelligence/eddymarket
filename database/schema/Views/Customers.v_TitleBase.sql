SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Customers].[v_TitleBase]
AS
SELECT t.ID,
       t.Name
FROM Customers.t_Title AS t;



GO

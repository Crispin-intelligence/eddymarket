SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_BonusTypeBase]
AS
SELECT t.ID,
       t.Name
FROM Employees.t_BonusType AS t;



GO

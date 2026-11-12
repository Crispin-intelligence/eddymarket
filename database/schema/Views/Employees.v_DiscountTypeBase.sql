SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_DiscountTypeBase]
AS
SELECT t.ID,
       t.Name
FROM Employees.t_DiscountType AS t;


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Employees].[v_DiscountAllBase]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateCreate
FROM Employees.t_Discount AS t
UNION ALL
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateCreate
FROM Employees.t_DiscountHistory AS t;

GO

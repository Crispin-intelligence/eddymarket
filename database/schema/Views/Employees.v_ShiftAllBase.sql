SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_ShiftAllBase]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateCreate
FROM Employees.t_Shift AS t
UNION ALL
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateCreate
FROM Employees.t_ShiftHistory AS t;



GO

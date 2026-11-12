SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Employees].[v_NationalityBase]
AS
SELECT ID,
       Name
FROM Employees.t_Nationality AS t;





GO

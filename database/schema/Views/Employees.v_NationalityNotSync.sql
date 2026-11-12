SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_NationalityNotSync]
AS
SELECT t.ID ,
       t.Name ,
       t.DescriptionIs ,
       t.EmployeeC ,
       t.CustomerC ,
       t.SearchText ,
       t.DateCreate
  FROM Employees.t_Nationality AS t
  WHERE t.IsSync = 0;



GO

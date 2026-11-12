SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_BonusType]
AS
SELECT t.ID,
       t.Name,
       t.DescriptionIs,
       t.BonusTotalD,
       t.BonusTotalLL,
       t.BonusTotalEuro,
       t.BonusC,
       t.DateCreate
FROM Employees.t_BonusType AS t;



GO

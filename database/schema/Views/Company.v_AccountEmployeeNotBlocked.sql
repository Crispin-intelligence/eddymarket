SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_AccountEmployeeNotBlocked]
AS
SELECT t.ID,
       t.Name,
       t.NumberF,
	   t.ShowInGymClass,
	   t.ShowInPersonalTrainer
FROM Company.t_Account AS t
WHERE t.StatusIs <> 2
      AND (t.NumberIs
      BETWEEN 4210100000 AND 4219999999
          );



GO

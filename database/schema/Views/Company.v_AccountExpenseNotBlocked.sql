SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_AccountExpenseNotBlocked]
AS
SELECT t.ID,
       t.Name,
       t.NumberF
FROM Company.t_Account AS t
WHERE t.StatusIs <> 2
      AND (t.NumberIs
      BETWEEN 6200000000 AND 6299999999
          );




GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_AccountPurchaseNotBlocked]
AS
SELECT t.ID,
       t.Name,
       t.NumberF
FROM Company.t_Account AS t
WHERE t.StatusIs <> 2
      AND (t.NumberIs
      BETWEEN 6010100000 AND 6010199999
          );


GO

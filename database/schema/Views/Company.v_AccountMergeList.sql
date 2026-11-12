SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountMergeList]
AS
SELECT t.ID,
       t.AccountID,
       t.AccountWith,
       t.AccountWithNumberF,
       t.DateCreate
FROM Company.t_AccountMerge AS t;



GO

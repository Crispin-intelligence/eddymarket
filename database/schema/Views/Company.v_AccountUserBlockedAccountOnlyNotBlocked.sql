SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create VIEW [Company].[v_AccountUserBlockedAccountOnlyNotBlocked]
AS
SELECT t.ID,
       t.UserID,
       t.Account,
	   t.CanUse,
       t.DateCreate
FROM Company.t_AccountUserBlocked AS t
LEFT JOIN Company.t_Account AS t1
ON t1.ID = t.AccountID
WHERE t1.StatusIs <> 2;



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_AccountUserBlockedUserOnlyNotBlocked]
AS
SELECT t.ID,
       t.AccountID,
       t.UserIs,
	   t.CanUse,
       t.DateCreate
FROM Company.t_AccountUserBlocked AS t
LEFT JOIN Users.t_User AS t1 ON t1.ID = t.UserID
WHERE t1.IsEnable = 1;



GO

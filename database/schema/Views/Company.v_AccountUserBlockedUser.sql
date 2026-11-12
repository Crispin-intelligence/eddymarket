SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountUserBlockedUser]
AS
SELECT t.ID,
       t.AccountID,
       t.UserIs,
	   t.CanUse,
       t.DateCreate
FROM Company.t_AccountUserBlocked AS t;






GO

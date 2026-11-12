SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_AccountUserBlockedBase]
AS
SELECT t.ID,
       t.AccountID,
       t.UserID,
	   t.CanUse
FROM Company.t_AccountUserBlocked AS t;






GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountUserBlockedBaseOnlyNotCanUse]
AS
SELECT t.ID,
       t.AccountID,
       t.UserID
FROM Company.t_AccountUserBlocked AS t
WHERE t.CanUse = 0;


GO

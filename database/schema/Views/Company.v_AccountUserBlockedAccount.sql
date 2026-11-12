SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountUserBlockedAccount]
AS
SELECT t.ID,
       t.UserID,
       t.Account,
	   t.CanUse,
       t.DateCreate
FROM Company.t_AccountUserBlocked AS t;







GO

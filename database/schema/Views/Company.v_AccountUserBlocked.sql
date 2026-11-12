SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_AccountUserBlocked]
AS
SELECT t.ID,
       t.AccountID,
       t.Account,
       t.UserID,
       t.UserIs,
	   t.CanUse,
       t.DateCreate
FROM Company.t_AccountUserBlocked AS t;






GO

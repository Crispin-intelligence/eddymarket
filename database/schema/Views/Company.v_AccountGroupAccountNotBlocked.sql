SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountGroupAccountNotBlocked]
AS
SELECT t.ID,
       t.AccountGroupID,
       t.AccountGroup,
       t.AccountID,
       t.Account,
	   t1.NumberF,
       t.DateCreate
FROM Company.t_AccountGroupAccount AS t
LEFT JOIN Company.t_Account AS t1
ON t1.ID = t.AccountID
WHERE t1.StatusIs <> 2;





GO

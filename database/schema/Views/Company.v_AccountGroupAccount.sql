SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_AccountGroupAccount]
AS
SELECT t.ID,
       t.AccountGroupID,
       t.AccountGroup,
       t.AccountID,
       t.Account,
       t.DateCreate
FROM Company.t_AccountGroupAccount AS t;



GO

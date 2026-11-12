SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_AccountGroupRange]
AS
SELECT t.ID,
       t.AccountGroupID,
       t.AccountGroup,
       t.FromNumber,
       t.ToNumber,
       t.DateCreate
FROM Company.t_AccountGroupRange AS t;




GO

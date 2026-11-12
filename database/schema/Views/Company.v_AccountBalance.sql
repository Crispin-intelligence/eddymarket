SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountBalance]
AS
SELECT t.ID,
       t.NumberIs,
       t.Name,
       t.Balance
FROM Company.t_Account AS t;


GO

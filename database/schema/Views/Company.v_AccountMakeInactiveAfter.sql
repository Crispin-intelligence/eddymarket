SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountMakeInactiveAfter]
AS
SELECT t.ID,
       t.Name,
       t.MakeInactiveAfter,
       t.MakeInactiveAfterType
FROM Company.t_Account AS t;





GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_AccountGroupList]
AS
SELECT t.ID,
       t.Name,
       t.Currency,
       t.TypeIs,
	   t.DescriptionIs,
       t.AccountC,
       t.AccountNames,
       t.RangeC,
       t.RangeNames,
       t.DateCreate
FROM Company.t_AccountGroup AS t;



GO

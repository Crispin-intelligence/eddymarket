SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountListBlocked]
AS
SELECT t.ID,
       t.SectionID,
       t.LinkWithID,
       t.LinkWith,
       t.NumberF,
	   t.NumberIs,
       t.NumberNet,
       t.Name,
       t.Balance,
       t.BalanceF,
       t.BalanceD,
       t.BalanceLL,
       t.BalanceEuro,
       t.LimitF,
       t.LimitD,
       t.DescriptionIs,
	   t.UserBlockedC,
	   t.UsersNames,
	   t.AccountMergeC,
	   t.AccountMergeNames,
	   t.StatusIs,
	   t.WhyThisStatus,
	   t.LastAction,
	   t.MakeInactiveAfter,
	   t.MakeInactiveAfterType,
       t.DateCreate
FROM Company.t_Account AS t
WHERE t.StatusIs = 2;



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Company].[v_AccountMerge]
AS
SELECT t.ID,
       t.AccountID,
       t.Account,
       t.AccountNumber,
       t.AccountNumberF,
       t.AccountIDWith,
       t.AccountWith,
       t.AccountWithNumber,
       t.AccountWithNumberF,
       t.DateCreate
FROM Company.t_AccountMerge AS t;



GO

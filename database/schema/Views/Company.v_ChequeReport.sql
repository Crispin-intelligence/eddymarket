SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_ChequeReport]
AS
SELECT t.ID,
       t.BankID,
       t1.Name AS ToAccount,
       t1.LinkWith AS LinkWith,
       t.Currency,
       t.Amount,
       t.AmountAR,
       t.AmountEN,
       t.Building,
       t.Crosscheck,
       t.DateDue,
       t.DescriptionIs
FROM Company.t_Cheque AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.ToAccountID;



GO

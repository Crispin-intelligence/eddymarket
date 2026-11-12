SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Company].[v_ChequeListWithoutImage]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.NumberIs,
       t.DateIs,
       t.BankID,
       t.Bank,
	   t.FromAccountID,
       t1.Name AS FromAccount,
       t1.NumberF AS FromAccountNumberF,
       t.ToAccountID,
       t2.Name AS ToAccount,
       t2.NumberF AS ToAccountNumberF,
       t.Currency,
       t.ExchangeRate,
       t.AmountF,
       t.AmountD,
       t.AmountLL,
       t.AmountEuro,
       t.Building,
       t.Crosscheck,
       t.TypeIs,
       t.DateDue,
       t.NotificationBeforeDays,
       t.NotificationDate,
       t.NotificationStop,
       t.DescriptionIs,
       t.DateCreate
FROM Company.t_Cheque AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.FromAccountID
    LEFT JOIN Company.t_Account AS t2
        ON t2.ID = t.ToAccountID;








GO

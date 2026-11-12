SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_ChequeHistory]
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
       t.ToAccountID,
       t2.Name AS ToAccount,
       t.CurrencyID,
       t.Currency,
       t.ExchangeRate,
       t.Amount,
       t.AmountF,
       t.AmountD,
       t.AmountLL,
       t.AmountEuro,
       t.AmountAR,
       t.AmountEN,
       t.BuildingID,
       t.Building,
       t.Crosscheck,
       t.TypeIs,
       t.ImageIs,
       t.DateDue,
       t.NotificationBeforeDays,
       t.NotificationDate,
       t.NotificationStop,
	   t.NotificationTextAR,
	   t.NotificationTextEN,
       t.DescriptionIs,
	   t.DateCreate
FROM Company.t_ChequeHistory AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.FromAccountID
    LEFT JOIN Company.t_Account AS t2
        ON t2.ID = t.ToAccountID;





GO

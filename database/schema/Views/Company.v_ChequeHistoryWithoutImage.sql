SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_ChequeHistoryWithoutImage]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.NumberIs,
       t.DateIs,
       t.BankID,
       t.Bank,
       t.FromAccountID,
       t.ToAccountID,
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
       t.DateDue,
       t.NotificationBeforeDays,
       t.NotificationDate,
       t.NotificationStop,
       t.DescriptionIs,
	   t.DateCreate
FROM Company.t_ChequeHistory AS t;





GO

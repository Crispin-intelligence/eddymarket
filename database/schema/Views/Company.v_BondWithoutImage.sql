SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Company].[v_BondWithoutImage]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.NumberIs,
       t.NumberOfGroup,
       t.DateIs,
       t.FromAccountID,
       t.ToAccountID,
	   t.StatesIs,
	   t.RegionIs,
	   t.Street,
	   t.AddressIs,
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
       t.TypeIs,
	   t.IsPaid,
       t.DateDue,
       t.NotificationBeforeDays,
       t.NotificationDate,
       t.NotificationStop,
       t.DescriptionIs,
       t.DateCreate
FROM Company.t_Bond AS t;









GO

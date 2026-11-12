SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_BondHistoryList]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.NumberIs,
       t.NumberOfGroup,
       t.DateIs,
       t1.Name AS FromAccount,
       t1.NumberF AS FromAccountNumberF,
       t.ToAccountID,
       t2.Name AS ToAccount,
       t2.NumberF AS ToAccountNumberF,
	   t.StatesIs,
	   t.RegionIs,
	   t.Street,
	   t.AddressIs,
       t.Currency,
       t.ExchangeRate,
       t.Amount,
       t.AmountF,
       t.AmountD,
       t.AmountLL,
       t.AmountEuro,
       t.AmountAR,
       t.AmountEN,
       t.Building,
       t.TypeIs,
       t.ImageIs,
	   t.IsPaid,
       t.DateDue,
       t.NotificationBeforeDays,
       t.NotificationDate,
       t.NotificationStop,
       t.DescriptionIs,
       t.DateCreate
FROM Company.t_BondHistory AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.FromAccountID
    LEFT JOIN Company.t_Account AS t2
        ON t2.ID = t.ToAccountID;









GO

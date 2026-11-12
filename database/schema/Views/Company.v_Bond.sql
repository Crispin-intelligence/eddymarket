SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_Bond]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.NumberIs,
       t.NumberOfGroup,
       t.DateIs,
       t.FromAccountID,
       t1.Name AS FromAccount,
       t.ToAccountID,
       t2.Name AS ToAccount,
       t.StatesID,
       t.StatesIs,
       t.RegionID,
       t.RegionIs,
       t.StreetID,
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
       t.ImageIs,
       t.IsPaid,
       t.DateDue,
       t.NotificationBeforeDays,
       t.NotificationDate,
       t.NotificationStop,
       t.NotificationTextAR,
       t.NotificationTextEN,
       t.DescriptionIs,
       t.DateCreate
FROM Company.t_Bond AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.FromAccountID
    LEFT JOIN Company.t_Account AS t2
        ON t2.ID = t.ToAccountID;



GO

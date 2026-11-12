SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_AccountItemPriceNotSync]
AS
SELECT t.ID,
       t.AccountID,
       t.ItemSharedID,
       t.ItemUnityID,
       t.Unity,
       t.CurrencyID,
       t.Currency,
       t.Price,
       t.PriceF,
       t.PriceD,
	   t.DiscountIs,
	   t.DiscountIsF,
       t.SectionIs,
       t.DateCreate
FROM Company.t_AccountItemPrice AS t
WHERE t.IsSync = 0;





GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ItemSharedEditCost]
AS
SELECT t.ID,
       t.Barcode,
       t.QtyCurrent,
       t.CurrencyID,
       t2.TypeIs,
       t.Purchase,
       t.PurchaseF,
       t.PurchaseWithTax,
       t.PurchaseWithTaxF
FROM Items.t_ItemShared AS t
    LEFT JOIN Currencys.t_Currency AS t2
        ON t2.ID = t.CurrencyID;




GO

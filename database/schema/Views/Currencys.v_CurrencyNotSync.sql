SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Currencys].[v_CurrencyNotSync]
AS
SELECT t.ID,
       t.TypeIs,
       t.Name,
       t.ExchangeRate,
       t.ExchangeRateTax,
       t.DecimalNumber,
       t.PositivePattern,
       t.DisplayFormat,
       t.DisplayFormat1,
       t.DisplayFormat2,
       t.DescriptionAR,
       t.DescriptionEN,
       t.DescriptionDecimalAR,
       t.DescriptionDecimalEN,
       t.RewardPointsInsteadOf,
       t.MinimumUnit,
       t.RoundingAfter,
       t.DateCreate,
       t.AccountC,
       t.EmployeeC,
       t.EmployeeDiscountC,
       t.ItemC,
       t.ItemCompilationC,
       t.PurchaseC,
       t.PurchaseReturnC,
       t.SellC,
       t.SellReturnC,
       t.InventoryAdjustmentC,
       t.QuotationC,
       t.QuotationTemplateC,
       t.ChequeC,
       t.VoucherC,
       t.TransactionC,
       t.TrialBalanceTemplateC
FROM Currencys.t_Currency AS t
WHERE t.IsSync = 0;





GO

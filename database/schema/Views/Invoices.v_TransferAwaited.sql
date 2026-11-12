SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_TransferAwaited]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateIs,
       t.DateOnly,
       t.DateMonthly,
       t.DateYearly,
       t.FromWarehouseID,
       t.FromWarehouse,
       t.ToWarehouseID,
       t.ToWarehouse,
       t.UserID,
       t.UserIs,
       t.CurrencyID,
       t.Currency,
       t.ExchangeRate,
       t.ExchangeRateLL,
       t.ExchangeRateEuro,
       t.Total,
       t.TotalF,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       t.TaxRate,
       t.TaxRateF,
       t.TaxValue,
       t.TaxValueF,
       t.TaxValueD,
       t.TaxValueLL,
       t.TaxValueEuro,
       t.NetIs,
       t.NetIsF,
       t.NetIsD,
       t.NetIsLL,
       t.NetIsEuro,
       t.NetIsAR,
       t.NetIsEN,
       t.DescriptionIs,
       t.ItemsNames,
       t.Qtys,
       t.DateCreate
FROM Invoices.t_TransferAwaited AS t;

GO

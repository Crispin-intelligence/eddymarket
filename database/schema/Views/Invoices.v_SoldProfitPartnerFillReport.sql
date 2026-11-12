SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_SoldProfitPartnerFillReport]
AS
SELECT  t.ID ,
        t1.RefF ,
        t1.DateOnly ,
        t1.AccountCustomer ,
        t1.NetIsF ,
        t.ProfitPartnerID ,
        t.ProfitPartner ,
        t.ProfitRatio ,
        t2.TypeIs AS CurrencyTypeIs ,
        t.ProfitF ,
        t.ProfitD ,
        t.ProfitLL ,
        t.ProfitEuro ,
        t.Paid
FROM    Invoices.t_SoldProfitPartner AS t
INNER JOIN Invoices.t_Sold AS t1 ON t1.ID = t.SoldID
INNER JOIN Currencys.t_Currency AS t2 ON t2.ID = t1.CurrencyID;



GO

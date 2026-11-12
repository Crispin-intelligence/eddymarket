SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_SoldDetailProfitPartnerNotSync]
AS
SELECT  t.ID ,
        t.SoldID ,
        t.SoldDetailID ,
        t.ProfitPartnerID ,
        t.ProfitPartner ,
        t.ProfitRatio ,
        t.Profit ,
        t.ProfitF ,
        t.ProfitD ,
        t.ProfitLL ,
        t.ProfitEuro ,
        t.SearchText ,
        t.DateCreate
FROM    Invoices.t_SoldDetailProfitPartner AS t
WHERE   t.IsSync = 0;
  

GO

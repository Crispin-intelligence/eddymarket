SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_SoldProfitPartner]
AS
SELECT t.ID ,
       t.SoldID ,
       t.ProfitPartnerID ,
       t.ProfitPartner ,
       t.ProfitRatio ,
       t.Profit ,
       t.ProfitF ,
       t.ProfitD ,
       t.ProfitLL ,
       t.ProfitEuro ,
       t.Paid ,
       t.SearchText ,
       t.DateCreate ,
       t.IsSync
FROM Invoices.t_SoldProfitPartner AS t;





GO

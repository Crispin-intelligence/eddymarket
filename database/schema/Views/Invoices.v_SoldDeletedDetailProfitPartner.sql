SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_SoldDeletedDetailProfitPartner]
AS
SELECT t.ID ,
       t.SoldDeletedID ,
       t.SoldDeletedDetailID ,
       t.ProfitPartnerID ,
       t.ProfitPartner ,
       t.ProfitRatio ,
       t.Profit ,
       t.ProfitF ,
       t.ProfitD ,
       t.ProfitLL ,
       t.ProfitEuro ,
       t.SearchText ,
       t.DateCreate ,
       t.IsSync
FROM Invoices.t_SoldDeletedDetailProfitPartner AS t;





GO

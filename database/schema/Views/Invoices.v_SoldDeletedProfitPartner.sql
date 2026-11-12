SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_SoldDeletedProfitPartner]
AS
SELECT t.ID ,
       t.SoldDeletedID ,
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
FROM Invoices.t_SoldDeletedProfitPartner AS t;





GO

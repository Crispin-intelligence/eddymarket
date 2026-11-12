SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_SoldProfitPartnerList]
AS
SELECT t.ID ,
       t.SoldID ,
	   t1.Ref,
	   t1.RefF,
	   t1.DateIs,
	   t1.AccountCustomer,
	   t1.NetIsF,
	   t1.NetIsD,
       t.ProfitPartnerID ,
       t.ProfitPartner ,
       t.ProfitRatio ,
       t.ProfitF ,
       t.ProfitD ,
       t.ProfitLL ,
       t.ProfitEuro ,
       t.Paid ,
       t.DateCreate ,
       t.IsSync
FROM Invoices.t_SoldProfitPartner AS t
INNER JOIN Invoices.t_Sold AS t1 ON t1.ID = t.SoldID;






GO

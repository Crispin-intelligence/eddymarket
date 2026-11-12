SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Invoices].[v_SoldReportAddressAndClassificationSum]
AS
SELECT COUNT(t.ID) AS NumbersInvoice,
       SUM(t.Qtys) AS Qtys,
       SUM(t.NetIsD) AS NetIsD,
       SUM(t.NetIsLL) AS NetIsLL,
       SUM(t.NetIsEuro) AS NetIsEuro,
       SUM(t.ProfitD) AS ProfitD,
       SUM(t.ProfitLL) AS ProfitLL,
       SUM(t.ProfitEuro) AS ProfitEuro
FROM Invoices.t_Sold AS t;



GO

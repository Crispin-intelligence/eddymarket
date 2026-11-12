SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ProfitPartner]
AS
SELECT t.ID ,
       t.Name ,
       t.DescriptionIs ,
       t.ItemsCount ,
       t.SalesInvoicesCount ,
       t.TotalProfitD ,
       t.TotalProfitLL ,
       t.TotalProfitEuro ,
       t.SearchText ,
       t.DateCreate ,
       t.IsMaster ,
       t.IsEnabled ,
       t.IsSync
FROM Items.t_ProfitPartner AS t;



GO

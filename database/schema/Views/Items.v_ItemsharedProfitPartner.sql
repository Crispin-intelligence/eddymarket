SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Items].[v_ItemsharedProfitPartner]
AS
SELECT t.ID ,
       t.ItemSharedID ,
       t.ProfitPartnerID ,
       t.ProfitPartner ,
       t.ProfitRatio ,
       t.DateCreate ,
       t.IsSync
FROM Items.t_ItemsharedProfitPartner AS t;




GO

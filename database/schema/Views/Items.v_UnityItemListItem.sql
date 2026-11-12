SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Items].[v_UnityItemListItem]
AS
SELECT t.ID,
       t.Unity,
       t.SharedID,
       t.Qty,
	   t.QtyCurrent,
       t.BarCode,
       t.PriceF,
       t.PriceD,
       t.PriceWithTaxF,
       t.PriceWithTaxD,
       t.CostF,
       t.CostD,
       t.CostWithTaxF,
       t.CostWithTaxD,
       t.DateCreate
FROM Items.t_UnityItem AS t;





GO

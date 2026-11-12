SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemSharedFillBarcode]
AS
SELECT t.ID,
       t.Name,
       t.Barcode,
       t.QtyCurrent,
       t.SellWithTaxF
FROM Items.t_ItemShared AS t;




GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemSharedBarCode]
AS
SELECT t.ID,
       t.SharedID,
       t.BarCode,
       t.BarcodeNumber,
       t.TypeIs,
       t.DateCreate
FROM Items.t_ItemSharedBarCode AS t;



GO

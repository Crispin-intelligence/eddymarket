SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ItemSharedBarCodeNotSync]
AS
SELECT t.ID ,
       t.SharedID ,
       t.BarCode ,
       t.BarcodeNumber ,
       t.TypeIs ,
       t.DateCreate
FROM Items.t_ItemSharedBarCode AS t
WHERE t.IsSync = 0;




GO

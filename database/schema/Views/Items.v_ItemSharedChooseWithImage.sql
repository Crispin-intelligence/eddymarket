SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Items].[v_ItemSharedChooseWithImage]
AS
SELECT  t.ID ,
        t.Name ,
        t.Barcodes ,
        t.ImageThumbnail ,
        t.SellF ,
        t.Brand ,
        t.DescriptionAR ,
        t.DescriptionEN ,
        t.DescriptionIs ,
        t.DescriptionSearch ,
        t.QtyCurrent ,
        t.OrderBy ,
        t.DateCreate
FROM    Items.t_ItemShared AS t
WHERE   t.StatusIs <> 2;



GO

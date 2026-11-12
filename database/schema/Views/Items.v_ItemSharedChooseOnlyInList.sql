SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Items].[v_ItemSharedChooseOnlyInList]
AS
SELECT  t.ID ,
        t.Name ,
        t.Brand ,
        t.Barcodes ,
        t.MainCategoryID ,
        t.DescriptionAR ,
        t.DescriptionEN ,
        t.DescriptionIs ,
        t.DescriptionSearch ,
        t.QtyCurrent ,
        t.OrderBy ,
        t.DateCreate
FROM    Items.t_ItemShared AS t
WHERE   t.StatusIs <> 2
        AND t.InList = 1;







GO

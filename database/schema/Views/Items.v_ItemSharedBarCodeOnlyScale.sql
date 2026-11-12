SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemSharedBarCodeOnlyScale]
AS
SELECT t.ID,
       t.SharedID,
       t.BarCode,
       t1.ScaleType,
       t.TypeIs,
       t.DateCreate
FROM Items.t_ItemSharedBarCode AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.SharedID
WHERE t1.ScaleType <> 0;



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemSharedNameAndBarCodeNotBlocked]
AS
SELECT t.ID,
       t.BarCode
FROM Items.t_ItemSharedBarCode AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.SharedID
WHERE t1.StatusIs <> 2
UNION ALL
SELECT t.ID,
       t.Name
FROM Items.t_ItemShared AS t
WHERE t.StatusIs <> 2;



GO

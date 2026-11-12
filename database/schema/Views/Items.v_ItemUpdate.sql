SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemUpdate]
AS
SELECT t.ID,
       t1.Name,
       t1.Barcode,
       t.QtyCurrent
FROM Items.t_Item AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.SharedID;



GO

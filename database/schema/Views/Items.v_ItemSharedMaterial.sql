SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemSharedMaterial]
AS
SELECT t.ID,
       t.ItemSharedFatherID,
       t.ItemSharedID,
       t.ItemUnityID,
       t.Qty,
       t.QtyWithUnity,
       t.Qtys,
       t.DescriptionIs,
       t.DateCreate,
       t.CreateByID,
       t.CreateBy
FROM Items.t_ItemSharedMaterial AS t;




GO

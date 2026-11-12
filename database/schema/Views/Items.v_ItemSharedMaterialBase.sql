SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemSharedMaterialBase]
AS
SELECT t.ID,
       t.ItemSharedFatherID,
       t.ItemSharedID,
       t.ItemUnityID,
       t.DateCreate
FROM Items.t_ItemSharedMaterial AS t;



GO

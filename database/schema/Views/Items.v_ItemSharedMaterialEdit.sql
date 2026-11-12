SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemSharedMaterialEdit]
AS
SELECT t.ID,
       t1.Name AS NameFather,
       t.ItemSharedID,
       t2.Name,
       t.Qty,
	   t3.Unity,
	   t.QtyWithUnity,
       t.DescriptionIs
FROM Items.t_ItemSharedMaterial AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedFatherID
    LEFT OUTER JOIN Items.t_ItemShared AS t2
        ON t.ItemSharedID = t2.ID
    LEFT JOIN Items.t_UnityItem AS t3
        ON t3.ID = t.ItemUnityID;






GO

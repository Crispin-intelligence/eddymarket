SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Items].[v_ItemSerial]
AS
SELECT t.ID,
       t.ItemSharedID,
       t.ItemID,
       t.SerialText,
       t.IsAvailable,
       t.SectionType,
       t.LinkID,
	   t.LastSectionID,
       t.DateCreate
FROM Items.t_ItemSerial AS t;




GO

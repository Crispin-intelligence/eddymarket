SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemSerialOnlyInTransfer]
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
FROM Items.t_ItemSerial AS t
WHERE t.IsAvailable = 1 OR t.IsAvailable = 2;






GO

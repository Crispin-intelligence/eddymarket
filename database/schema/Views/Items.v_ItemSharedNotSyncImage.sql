SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemSharedNotSyncImage]
AS
SELECT t.ID,
       t.Name,
       t.ImageIs,
       t.ImagePath
FROM Items.t_ItemShared AS t
WHERE t.IsSyncImage = 0;



GO

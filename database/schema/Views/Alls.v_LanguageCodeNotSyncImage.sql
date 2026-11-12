SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Alls].[v_LanguageCodeNotSyncImage]
AS
SELECT t.ID,
       t.Name,
       t.ImageIs,
       t.ImagePath
FROM Alls.t_LanguageCode AS t
WHERE t.IsSyncImage = 0;


GO

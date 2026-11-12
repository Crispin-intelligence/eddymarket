SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_DoctorNotSyncImage]
AS
SELECT t.ID,
       t.Name,
       t.ImageIs,
       t.ImagePath
FROM Company.t_Doctor AS t
WHERE t.IsSyncImage = 0;



GO

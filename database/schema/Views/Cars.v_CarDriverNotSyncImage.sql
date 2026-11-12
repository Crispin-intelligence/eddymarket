SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarDriverNotSyncImage]
AS
SELECT  t.ID ,
        t.Name ,
        t.ImageIs ,
        t.ImagePath
FROM    Cars.t_CarDriver AS t
WHERE   t.IsSyncImage = 0;





GO

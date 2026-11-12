SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_FileStorageStopNotification]
AS
SELECT t.ID,
       t.Name,
       t.StopNotification
FROM Company.t_FileStorage AS t;


GO

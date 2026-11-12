SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_FileStorageTypeBase]
AS
SELECT t.ID,
       t.Name
FROM Company.t_FileStorageType AS t;


GO

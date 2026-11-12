SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_FileStorageShort1]
AS
SELECT t.ID,
       t.TypeIsID,
       t.Name,
       t.DescriptionIs,
       t.FileNameIs,
       t.FileExtension,
       t.SizeF,
       t.DateCreate
FROM Company.t_FileStorage AS t;




GO

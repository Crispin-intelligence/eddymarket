SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Company].[v_FileStorageLinkedTypeList]
AS
SELECT t.ID,
       t2.Name AS OwnerName,
       t.SectionID,
       t.FileStorage,
       CONVERT(NVARCHAR(MAX), t1.TypeIsID) AS TypeIsID,
       t.DateCreate
FROM Company.t_FileStorageLinked AS t
    LEFT OUTER JOIN Company.t_FileStorage AS t1
        ON t.FileStorageID = t1.ID
    LEFT JOIN Alls.v_Person AS t2
        ON t2.ID = t.OwnerID;







GO

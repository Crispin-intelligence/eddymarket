SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_FileStorageLinkedSalesPerson]
AS
SELECT  t.ID ,
        t.OwnerID ,
        t.SectionID ,
        t.FileStorageID ,
        t.FileStorage ,
        t1.TypeIs ,
        t1.FileExtension ,
        t1.Size ,
        t1.SizeF ,
        t1.ExpirationDate ,
        t1.StopNotification ,
        t.DateCreate
FROM    Company.t_FileStorageLinked AS t
INNER JOIN Company.t_FileStorage AS t1 ON t1.ID = t.FileStorageID
WHERE   t.SectionID = 149;





GO

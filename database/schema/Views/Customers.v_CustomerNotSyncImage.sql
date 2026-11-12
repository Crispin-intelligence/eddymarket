SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Customers].[v_CustomerNotSyncImage]
AS
SELECT  t.ID ,
        t.Name ,
        t.ImageIs ,
        t.ImagePath
FROM    Customers.t_Customer AS t
WHERE   t.IsSyncImage = 0;




GO

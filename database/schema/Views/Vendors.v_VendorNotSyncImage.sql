SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Vendors].[v_VendorNotSyncImage]
AS
SELECT t.ID,
       t.Name,
       t.ImageIs,
       t.ImagePath
FROM Vendors.t_Vendor AS t
WHERE t.IsSyncImage = 0;



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Vendors].[v_VendorBaseNotBlocked]
AS
SELECT t.ID,
       t.Name
FROM Vendors.t_Vendor AS t
WHERE t.StatusIs <> 2;




GO

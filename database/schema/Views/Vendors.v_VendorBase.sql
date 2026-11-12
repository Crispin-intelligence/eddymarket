SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Vendors].[v_VendorBase]
AS
SELECT t.ID,
       t.Name
FROM Vendors.t_Vendor AS t;



GO

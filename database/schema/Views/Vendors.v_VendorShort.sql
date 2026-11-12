SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Vendors].[v_VendorShort]
AS
SELECT t.ID,
       t.Name,
       t.Phones,
       t.AddressIs
FROM Vendors.t_Vendor AS t;



GO

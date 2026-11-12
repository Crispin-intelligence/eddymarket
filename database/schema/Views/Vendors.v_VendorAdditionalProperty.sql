SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Vendors].[v_VendorAdditionalProperty]
AS
SELECT t.ID,
       t.Name,
       t.AdditionalProperty1,
       t.AdditionalProperty2,
       t.AdditionalProperty3,
       t.AdditionalProperty4,
       t.AdditionalProperty5,
       t.AdditionalProperty6,
       t.AdditionalProperty7,
       t.AdditionalProperty8,
       t.AdditionalProperty9,
       t.AdditionalProperty10,
       t.DateCreate
FROM Vendors.t_Vendor AS t;



GO

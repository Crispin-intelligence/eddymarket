SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemSharedVendorListItem]
AS
SELECT t.ID,
       t.SharedID,
       t.Vendor,
       t.PriceF,
       t.PriceD,
       t.DescriptionIs,
       t.DateCreate
FROM Items.t_ItemSharedVendor AS t;


GO

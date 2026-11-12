SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemSharedVendorBase]
AS
SELECT t.ID,
       t.SharedID,
       t.VendorID,
       t.DateCreate
FROM Items.t_ItemSharedVendor AS t;


GO

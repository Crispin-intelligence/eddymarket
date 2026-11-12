SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemSharedBase]
AS
SELECT t.ID,
       t.Name,
       t.NameInvoice,
       t.Barcode,
       t.DateCreate
FROM Items.t_ItemShared AS t;


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemSharedAdditionalProperty]
AS
SELECT t.ID,
       t.Name,
	   t.Barcode,
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
FROM Items.t_ItemShared AS t;



GO

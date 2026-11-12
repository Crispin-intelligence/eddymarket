SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemListItem]
AS
SELECT t.ID,
       t.SharedID,
       t.WareHouse,
       t.Place,
       t.QtyCurrent,
	   t.QtyCurrentByUnit,
       t.DateCreate
FROM Items.t_Item AS t;



GO

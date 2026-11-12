SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Customers].[v_FrameJobOrderDetailShortList]
AS
SELECT  t.ID ,
        t.FrameJobOrderID ,
        t1.Name ,
        t1.Barcode ,
        t.QtyWithUnity ,
		t.ItemType,
        t.Total ,
        t.TotalF ,
        t.SortAt
FROM    Customers.t_FrameJobOrderDetail AS t
        LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID;


GO

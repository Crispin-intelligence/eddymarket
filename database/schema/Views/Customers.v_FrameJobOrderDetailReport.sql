SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Customers].[v_FrameJobOrderDetailReport]
AS
SELECT  t.ID ,
        t.FrameJobOrderID ,
        t1.Name ,
        t1.Barcode ,
        t1.Brand ,
        t.Qty ,
        t.Qtys ,
        t.QtyWithUnity ,
        t.ItemType ,
        t.Cost ,
        t.TotalCost ,
        t.DescriptionIs ,
        t.SortAt
FROM    Customers.t_FrameJobOrderDetail AS t
        LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID;




GO

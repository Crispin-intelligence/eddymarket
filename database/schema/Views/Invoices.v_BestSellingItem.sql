SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_BestSellingItem]
AS
SELECT  t.ID ,
        t.SoldID ,
        t1.DateOnly ,
        t.ItemSharedID ,
        t.Qtys ,
        t.TotalD ,
        t.TotalLL ,
        t.TotalEuro
FROM    Invoices.t_SoldDetail AS t
INNER JOIN Invoices.t_Sold AS t1 ON t1.ID = t.SoldID
INNER JOIN Items.t_ItemShared AS t2 ON t2.ID = t.ItemSharedID;




GO

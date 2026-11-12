SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_SubCategoryProfitD]
AS
SELECT t.ID,
       t1.DateOnly AS DateIs,
       t.ProfitTotalD AS Profit,
       t2.MainCategory,
       t2.SubCategory
FROM Invoices.t_SoldDetail AS t
    LEFT JOIN Invoices.t_Sold AS t1
        ON t1.ID = t.SoldID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID;




GO

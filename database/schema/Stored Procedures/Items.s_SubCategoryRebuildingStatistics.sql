SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_SubCategoryRebuildingStatistics]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    BEGIN --Rebuild statistics

      SET @Return = 0;

      UPDATE  Items.t_SubCategory
      SET     MainCategory = Items.f_MainCategoryGetName(MainCategoryID) ,
              ItemC = ( SELECT  COUNT(*) AS Total
                        FROM    Items.t_ItemShared AS t
                        WHERE   t.SubCategoryID = t_SubCategory.ID
                      ) ,
              PurchaseC = ( SELECT  COUNT(*) AS Total
                            FROM    Invoices.t_PurchasingDetail AS t
                            LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                            LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                            WHERE   ( t2.SubCategoryID = t_SubCategory.ID )
                          ) ,
              PurchaseQty = ( SELECT  ISNULL(SUM(t.Qtys), 0) AS Total
                              FROM    Invoices.t_PurchasingDetail AS t
                              LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                              LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                              WHERE   ( t2.SubCategoryID = t_SubCategory.ID )
                            ) ,
              PurchaseReturnC = ( SELECT  COUNT(*) AS Total
                                  FROM    Invoices.t_PurchasingReturnDetail AS t
                                  LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                                  LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                                  WHERE   ( t2.SubCategoryID = t_SubCategory.ID )
                                ) ,
              PurchaseReturnQty = ( SELECT  ISNULL(SUM(t.Qtys), 0) AS Total
                                    FROM    Invoices.t_PurchasingReturnDetail AS t
                                    LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                                    LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                                    WHERE   ( t2.SubCategoryID = t_SubCategory.ID )
                                  ) ,
              QuotationC = ( SELECT COUNT(*) AS Total
                             FROM   Quotations.t_QuotationDetail AS t
                             LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                             WHERE  ( t1.SubCategoryID = t_SubCategory.ID )
                           ) + ( SELECT COUNT(*) AS Total
                                 FROM   Quotations.t_QuotationDetail AS t
                                 LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                 WHERE  ( t1.SubCategoryID = t_SubCategory.ID )
                               ) ,
              QuotationQty = ( SELECT ISNULL(SUM(t.Qtys), 0) AS Total
                               FROM   Quotations.t_QuotationHistoryDetail AS t
                               LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                               WHERE  ( t1.SubCategoryID = t_SubCategory.ID )
                             ) + ( SELECT ISNULL(SUM(t.Qtys), 0) AS Total
                                   FROM   Quotations.t_QuotationHistoryDetail AS t
                                   LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                   WHERE  ( t1.SubCategoryID = t_SubCategory.ID )
                                 ) ,
              SellC = ( SELECT  COUNT(*) AS Total
                        FROM    Invoices.t_SoldDetail AS t
                        LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                        LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                        WHERE   ( t2.SubCategoryID = t_SubCategory.ID )
                      ) ,
              SellQty = ( SELECT  ISNULL(SUM(t.Qtys), 0) AS Total
                          FROM    Invoices.t_SoldDetail AS t
                          LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                          LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                          WHERE   ( t2.SubCategoryID = t_SubCategory.ID )
                        ) ,
              SellReturnC = ( SELECT  COUNT(*) AS Total
                              FROM    Invoices.t_SoldReturnDetail AS t
                              LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                              LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                              WHERE   ( t2.SubCategoryID = t_SubCategory.ID )
                            ) ,
              SellReturnQty = ( SELECT  ISNULL(SUM(t.Qtys), 0) AS Total
                                FROM    Invoices.t_SoldReturnDetail AS t
                                LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                                LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                                WHERE   ( t2.SubCategoryID = t_SubCategory.ID )
                              );

      UPDATE  Items.t_SubCategory
      SET     SearchText = Items.f_SubCategorySearchTextGet(ID);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_SubCategoryMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                '00000000-0000-0000-0000-000000000000' ,
                @Event ,
                6 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;


GO

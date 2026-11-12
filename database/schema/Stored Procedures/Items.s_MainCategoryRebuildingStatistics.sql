SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_MainCategoryRebuildingStatistics]
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

      UPDATE  Items.t_MainCategory
      SET     SubCategoryC = ( SELECT COUNT(*) AS Total
                               FROM   Items.t_SubCategory AS t
                               WHERE  t.MainCategoryID = t_MainCategory.ID
                             ) ,
              ItemC = ( SELECT  COUNT(*) AS Total
                        FROM    Items.t_ItemShared AS t
                        WHERE   t.MainCategoryID = t_MainCategory.ID
                      ) ,
              ItemInListCount = ( SELECT  COUNT(*) AS Total
                                  FROM    Items.t_ItemShared AS t
                                  WHERE   t.MainCategoryID = t_MainCategory.ID
                                          AND t.InList = 1
                                ) ,
              PurchaseC = ( SELECT  COUNT(*) AS Total
                            FROM    Invoices.t_PurchasingDetail AS t
                            LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                            LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                            WHERE   ( t2.MainCategoryID = t_MainCategory.ID )
                          ) ,
              PurchaseQty = ( SELECT  ISNULL(SUM(t.Qtys), 0) AS Total
                              FROM    Invoices.t_PurchasingDetail AS t
                              LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                              LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                              WHERE   ( t2.MainCategoryID = t_MainCategory.ID )
                            ) ,
              PurchaseReturnC = ( SELECT  COUNT(*) AS Total
                                  FROM    Invoices.t_PurchasingReturnDetail AS t
                                  LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                                  LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                                  WHERE   ( t2.MainCategoryID = t_MainCategory.ID )
                                ) ,
              PurchaseReturnQty = ( SELECT  ISNULL(SUM(t.Qtys), 0) AS Total
                                    FROM    Invoices.t_PurchasingReturnDetail AS t
                                    LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                                    LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                                    WHERE   ( t2.MainCategoryID = t_MainCategory.ID )
                                  ) ,
              QuotationC = ( SELECT COUNT(*) AS Total
                             FROM   Quotations.t_QuotationDetail AS t
                             LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                             WHERE  ( t1.MainCategoryID = t_MainCategory.ID )
                           ) + ( SELECT COUNT(*) AS Total
                                 FROM   Quotations.t_QuotationDetail AS t
                                 LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                 WHERE  ( t1.MainCategoryID = t_MainCategory.ID )
                               ) ,
              QuotationQty = ( SELECT ISNULL(SUM(t.Qtys), 0) AS Total
                               FROM   Quotations.t_QuotationHistoryDetail AS t
                               LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                               WHERE  ( t1.MainCategoryID = t_MainCategory.ID )
                             ) + ( SELECT ISNULL(SUM(t.Qtys), 0) AS Total
                                   FROM   Quotations.t_QuotationHistoryDetail AS t
                                   LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                   WHERE  ( t1.MainCategoryID = t_MainCategory.ID )
                                 ) ,
              SellC = ( SELECT  COUNT(*) AS Total
                        FROM    Invoices.t_SoldDetail AS t
                        LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                        LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                        WHERE   ( t2.MainCategoryID = t_MainCategory.ID )
                      ) ,
              SellQty = ( SELECT  ISNULL(SUM(t.Qtys), 0) AS Total
                          FROM    Invoices.t_SoldDetail AS t
                          LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                          LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                          WHERE   ( t2.MainCategoryID = t_MainCategory.ID )
                        ) ,
              SellReturnC = ( SELECT  COUNT(*) AS Total
                              FROM    Invoices.t_SoldReturnDetail AS t
                              LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                              LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                              WHERE   ( t2.MainCategoryID = t_MainCategory.ID )
                            ) ,
              SellReturnQty = ( SELECT  ISNULL(SUM(t.Qtys), 0) AS Total
                                FROM    Invoices.t_SoldReturnDetail AS t
                                LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                                LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                                WHERE   ( t2.MainCategoryID = t_MainCategory.ID )
                              );

      UPDATE  Items.t_MainCategory
      SET     SearchText = Items.f_MainCategorySearchTextGet(ID);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_MainCategoryMoving
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

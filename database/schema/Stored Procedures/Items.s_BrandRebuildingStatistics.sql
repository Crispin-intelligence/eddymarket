SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_BrandRebuildingStatistics]
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

      UPDATE  Items.t_Brand
      SET     ItemC = ( SELECT  COUNT(*) AS Total
                        FROM    Items.t_ItemShared AS s
                        WHERE   ( BrandID = t_Brand.ID )
                      ) ,
              SellC = ( SELECT  COUNT(*) AS Total
                        FROM    Invoices.t_SoldDetail AS t
                        LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                        LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                        WHERE   ( t2.BrandID = t_Brand.ID )
                      ) ,
              SellQty = ( SELECT  COALESCE(SUM(t.Qtys), 0) AS Total
                          FROM    Invoices.t_SoldDetail AS t
                          LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                          LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                          WHERE   ( t2.BrandID = t_Brand.ID )
                        ) ,
              SellReturnC = ( SELECT  COUNT(*) AS Total
                              FROM    Invoices.t_SoldReturnDetail AS t
                              LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                              LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                              WHERE   ( t2.BrandID = t_Brand.ID )
                            ) ,
              SellReturnQty = ( SELECT  COALESCE(SUM(t.Qtys), 0) AS Total
                                FROM    Invoices.t_SoldReturnDetail AS t
                                LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                                LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                                WHERE   ( t2.BrandID = t_Brand.ID )
                              ) ,
              PurchaseC = ( SELECT  COUNT(*) AS Total
                            FROM    Invoices.t_PurchasingDetail AS t
                            LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                            LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                            WHERE   ( t2.BrandID = t_Brand.ID )
                          ) ,
              PurchaseQty = ( SELECT  COALESCE(SUM(t.Qtys), 0) AS Total
                              FROM    Invoices.t_PurchasingDetail AS t
                              LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                              LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                              WHERE   ( t2.BrandID = t_Brand.ID )
                            ) ,
              PurchaseReturnC = ( SELECT  COUNT(*) AS Total
                                  FROM    Invoices.t_PurchasingReturnDetail AS s
                                  LEFT JOIN Items.t_Item AS t ON t.ID = s.ItemID
                                  LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.SharedID
                                  WHERE   ( t1.BrandID = t_Brand.ID )
                                ) ,
              PurchaseReturnQty = ( SELECT  COALESCE(SUM(t.Qtys), 0) AS Total
                                    FROM    Invoices.t_PurchasingReturnDetail AS t
                                    LEFT JOIN Items.t_Item AS t1 ON t1.ID = t.ItemID
                                    LEFT JOIN Items.t_ItemShared AS t2 ON t2.ID = t1.SharedID
                                    WHERE   ( t2.BrandID = t_Brand.ID )
                                  );

      UPDATE  Items.t_Brand
      SET     SearchText = Items.f_BrandSearchTextGet(ID);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_BrandMoving
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

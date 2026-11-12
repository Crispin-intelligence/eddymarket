SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_UnityRebuildingStatistics]
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

      UPDATE  Items.t_Unity
      SET     ItemC = ( SELECT  COUNT(*) AS Total
                        FROM    Items.t_UnityItem AS s
                        WHERE   ( s.UnityID = t_Unity.ID )
                      ) ,
              SellC = ( SELECT  COUNT(*) AS Total
                        FROM    Invoices.t_SoldDetail AS s
                        LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                        WHERE   ( s1.UnityID = t_Unity.ID )
                      ) ,
              SellQty = ( SELECT  COALESCE(SUM(s.Qtys), 0) AS Total
                          FROM    Invoices.t_SoldDetail AS s
                          LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                          WHERE   ( s1.UnityID = t_Unity.ID )
                        ) ,
              SellReturnC = ( SELECT  COUNT(*) AS Total
                              FROM    Invoices.t_SoldReturnDetail AS s
                              LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                              WHERE   ( s1.UnityID = t_Unity.ID )
                            ) ,
              SellReturnQty = ( SELECT  COALESCE(SUM(s.Qtys), 0) AS Total
                                FROM    Invoices.t_SoldReturnDetail AS s
                                LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                                WHERE   ( s1.UnityID = t_Unity.ID )
                              ) ,
              PurchaseC = ( SELECT  COUNT(*) AS Total
                            FROM    Invoices.t_PurchasingDetail AS s
                            LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                            WHERE   ( s1.UnityID = t_Unity.ID )
                          ) ,
              PurchaseQty = ( SELECT  COALESCE(SUM(s.Qtys), 0) AS Total
                              FROM    Invoices.t_PurchasingDetail AS s
                              LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                              WHERE   ( s1.UnityID = t_Unity.ID )
                            ) ,
              PurchaseReturnC = ( SELECT  COUNT(*) AS Total
                                  FROM    Invoices.t_PurchasingReturnDetail AS s
                                  LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                                  WHERE   ( s1.UnityID = t_Unity.ID )
                                ) ,
              PurchaseReturnQty = ( SELECT  COALESCE(SUM(s.Qtys), 0) AS Total
                                    FROM    Invoices.t_PurchasingReturnDetail AS s
                                    LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                                    WHERE   ( s1.UnityID = t_Unity.ID )
                                  );

      UPDATE  Items.t_Unity
      SET     SearchText = Items.f_UnitySearchTextGet(ID);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_UnityMoving
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

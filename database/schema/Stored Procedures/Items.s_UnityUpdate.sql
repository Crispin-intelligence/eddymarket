SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_UnityUpdate]
  @Name NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT ,
        @NameOld NVARCHAR(450);

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Items.t_Unity AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Items.t_Unity
      SET     Name = @Name ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

      UPDATE  Items.t_Unity
      SET     SearchText = Items.f_UnitySearchTextGet(ID)
      WHERE   ID = @ID;

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
                @ID ,
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN

      BEGIN --Fix t_UnityItem

        UPDATE  Items.t_UnityItem
        SET     Unity = @Name
        WHERE   UnityID = @ID;

      END;

      BEGIN; --Fix t_BeginningInventoryQuantityDetail

        WITH  o AS ( SELECT s.QtyWithUnity ,
                            s.Qty
                     FROM   Items.t_BeginningInventoryQuantityDetail AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.QtyWithUnity = FORMAT(o.Qty, 'n2') + ' ' + @Name;

      END;

      BEGIN; --Fix t_PurchasingDetail

        WITH  o AS ( SELECT s.QtyWithUnity ,
                            s.Qty
                     FROM   Invoices.t_PurchasingDetail AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.QtyWithUnity = FORMAT(o.Qty, 'n2') + ' ' + @Name;

      END;

      BEGIN; --Fix t_PurchasingDeletedDetail

        WITH  o AS ( SELECT s.QtyWithUnity ,
                            s.Qty
                     FROM   Invoices.t_PurchasingDeletedDetail AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.QtyWithUnity = FORMAT(o.Qty, 'n2') + ' ' + @Name;

      END;

      BEGIN; --Fix t_PurchasingReturnDetail

        WITH  o AS ( SELECT s.QtyWithUnity ,
                            s.Qty
                     FROM   Invoices.t_PurchasingReturnDetail AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.QtyWithUnity = FORMAT(o.Qty, 'n2') + ' ' + @Name;

      END;

      BEGIN; --Fix t_PurchasingReturnDeletedDetail

        WITH  o AS ( SELECT s.QtyWithUnity ,
                            s.Qty
                     FROM   Invoices.t_PurchasingReturnDeletedDetail AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.QtyWithUnity = FORMAT(o.Qty, 'n2') + ' ' + @Name;

      END;

      BEGIN; --Fix t_SoldDetail

        WITH  o AS ( SELECT s.QtyWithUnity ,
                            s.Qty
                     FROM   Invoices.t_SoldDetail AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.QtyWithUnity = FORMAT(o.Qty, 'n2') + ' ' + @Name;

      END;

      BEGIN; --Fix t_SoldDeletedDetail

        WITH  o AS ( SELECT s.QtyWithUnity ,
                            s.Qty
                     FROM   Invoices.t_SoldDeletedDetail AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.QtyWithUnity = FORMAT(o.Qty, 'n2') + ' ' + @Name;

      END;

      BEGIN; --Fix t_SoldReturnDetail

        WITH  o AS ( SELECT s.QtyWithUnity ,
                            s.Qty
                     FROM   Invoices.t_SoldReturnDetail AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.QtyWithUnity = FORMAT(o.Qty, 'n2') + ' ' + @Name;

      END;
     
      BEGIN; --Fix t_SoldReturnDeletedDetail

        WITH  o AS ( SELECT s.QtyWithUnity ,
                            s.Qty
                     FROM   Invoices.t_SoldReturnDeletedDetail AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.QtyWithUnity = FORMAT(o.Qty, 'n2') + ' ' + @Name;

      END;

      BEGIN; --Fix t_AccountItemPrice

        WITH  o AS ( SELECT s.Unity ,
                            s2.Name AS Unity_
                     FROM   Company.t_AccountItemPrice AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     LEFT JOIN Items.t_Unity AS s2 ON s2.ID = s1.UnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.Unity = o.Unity_;

      END;

      BEGIN; --Fix t_FrameJobOrderDetail

        WITH  o AS ( SELECT s.QtyWithUnity ,
                            s.Qty
                     FROM   Customers.t_FrameJobOrderDetail AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.QtyWithUnity = FORMAT(o.Qty, 'n2') + ' ' + @Name;

      END;

      BEGIN; --Fix t_FrameJobOrderHistoryDetail

        WITH  o AS ( SELECT s.QtyWithUnity ,
                            s.Qty
                     FROM   Customers.t_FrameJobOrderHistoryDetail AS s
                     LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                     WHERE  s1.UnityID = @ID
                   )
          UPDATE  o
          SET     o.QtyWithUnity = FORMAT(o.Qty, 'n2') + ' ' + @Name;

      END;

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

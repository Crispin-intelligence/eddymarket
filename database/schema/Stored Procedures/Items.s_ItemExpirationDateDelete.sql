SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemExpirationDateDelete]
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

      DECLARE @ItemSharedID UNIQUEIDENTIFIER ,
        @Barcode NVARCHAR(450) ,
        @Return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @ItemSharedID = s.ItemSharedID ,
              @Barcode = s.Barcode
      FROM    Items.t_ItemExpirationDate AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Delete

      SET @Return = 0;

      DELETE  FROM Items.t_ItemExpirationDate
      WHERE   ID = @ID;

    END;

    IF @Barcode <> N''
    BEGIN --Delete barcodes

      SET @Return = -3;

      DELETE  FROM Items.t_ItemSharedBarCode
      WHERE   SharedID = @ItemSharedID
              AND TypeIs = 3
              AND BarCode = @Barcode;
	
      BEGIN --Fix t_ItemShared

        UPDATE  Items.t_ItemShared
        SET     Barcodes = Alls.f_FixXML(( SELECT N', ' + t.BarCode AS [text()]
                                           FROM   Items.t_ItemSharedBarCode AS t
                                           WHERE  t.SharedID = t_ItemShared.ID
                                         FOR
                                           XML PATH('')
                                         ))
        WHERE   ID = @ItemSharedID;

        EXECUTE Items.s_ItemSharedUpdateSearchIndexPART @ItemSharedID;
		
      END;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_ItemExpirationDateMoving
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

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;









GO

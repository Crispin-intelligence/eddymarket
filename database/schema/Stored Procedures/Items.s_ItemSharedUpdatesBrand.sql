SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedUpdatesBrand] @BrandID UNIQUEIDENTIFIER ,
  @UserID UNIQUEIDENTIFIER ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @IDs Alls.tt_IDAndEvent READONLY
AS
BEGIN
  BEGIN TRY

    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @return INT;

    END;

    BEGIN --Update item shared

      SET @return = 0;

      UPDATE Items.t_ItemShared
        SET BrandID = @BrandID ,
            Brand = Items.f_BrandGetName(@BrandID)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_ItemShared.ID );

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Items.t_ItemSharedMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        SELECT @UserID ,
            s.ID ,
            s.EventIs ,
            @EventType ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          FROM @IDs AS s;

    END;

    COMMIT TRANSACTION;

    SELECT 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT @return;

  END CATCH;

END;







GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_WareHouseDelete]
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

      DECLARE @Return INT;

    END;

    BEGIN --Delete phones 

      DELETE  FROM Company.t_BookPhone
      WHERE   SectionID = 42
              AND OwnerID = @ID;

    END;

    BEGIN --Delete SocialMedia 

      DELETE  FROM Company.t_SocialMedia
      WHERE   SectionID = 42
              AND OwnerID = @ID;

    END;

    BEGIN --Delete item 

      DELETE  FROM Items.t_Item
      WHERE   WareHouseID = @ID;

    END;

    BEGIN --Delete place 

      DELETE  FROM Company.t_Place
      WHERE   WareHouseID = @ID;

    END;

    BEGIN --Delete

      SET @Return = 0;

      DELETE  FROM Company.t_WareHouse
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_WarehouseMoving
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

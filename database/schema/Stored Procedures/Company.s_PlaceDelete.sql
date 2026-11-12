SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_PlaceDelete]
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
        @WareHouseID UNIQUEIDENTIFIER ,
        @CountIs BIGINT;

    END;

    BEGIN --Set

      SELECT TOP ( 1 )
              @WareHouseID = s.WareHouseID
      FROM    Company.t_Place AS s
      WHERE   s.ID = @ID;

      SELECT  @CountIs = COUNT(*)
      FROM    Company.t_Place AS s
      WHERE   s.WareHouseID = @WareHouseID;

    END;

    BEGIN --Check

      IF @CountIs <= 1
      BEGIN

        ROLLBACK;

        RETURN 0;

      END;

    END;

    BEGIN --Delete

      SET @Return = 0;

      DELETE  FROM Company.t_Place
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_PlaceMoving
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

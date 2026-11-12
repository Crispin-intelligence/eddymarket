SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_MainCategoryUpdateOrderByLast]
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

      DECLARE @IDOld UNIQUEIDENTIFIER ,
        @OrderByOld BIGINT ,
        @OrderByNew BIGINT ,
        @Return INT = 0;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @OrderByOld = s.OrderBy
      FROM    Items.t_MainCategory AS s
      WHERE   s.ID = @ID;

      SELECT TOP ( 1 )
              @OrderByNew = MAX(s.OrderBy)
      FROM    Items.t_MainCategory AS s;
  
      IF @OrderByNew IS NULL
      BEGIN
                             
        RETURN 1;

      END;

      IF @OrderByOld = @OrderByNew
      BEGIN
                             
        RETURN 1;

      END;

      SELECT TOP ( 1 )
              @IDOld = s.ID
      FROM    Items.t_MainCategory AS s
      WHERE   s.OrderBy = @OrderByNew;

    END;

    BEGIN --Update

      UPDATE  Items.t_MainCategory
      SET     OrderBy = @OrderByNew
      WHERE   ID = @ID;
 
      UPDATE  Items.t_MainCategory
      SET     OrderBy = @OrderByOld
      WHERE   ID = @IDOld;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      DECLARE @Event2 NVARCHAR(MAX) = @Event;

      SET @Event = REPLACE(@Event, @OrderByOld, @OrderByNew);
      SET @Event2 = REPLACE(@Event2, @OrderByNew, @OrderByOld);

      INSERT  INTO Items.t_MainCategoryMoving
              ( UserID, SectionID, EventIs, EventType, ComputerIP, Computer, ComputerAccount )
      VALUES  ( @UserID, @ID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount ),
              ( @UserID, @IDOld, @Event2, @EventType, @ComputerIP, @Computer, @ComputerAccount );
 
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

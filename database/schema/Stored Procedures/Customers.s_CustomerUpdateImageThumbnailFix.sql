SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Customers].[s_CustomerUpdateImageThumbnailFix] @ImageThumbnail IMAGE ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY

    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @return INT;

    END;

    BEGIN --Update

      SET @return = 0;

      UPDATE Customers.t_Customer
        SET ImageThumbnail = @ImageThumbnail ,
            ImageThumbnailFixed = 1
        WHERE ID = @ID AND ImageThumbnailFixed = 0;

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Customers.t_CustomerMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        VALUES
          ( @UserID ,
            @ID ,
            @Event ,
            1 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    COMMIT TRANSACTION;

    RETURN  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN  @return;

  END CATCH;

END;








GO

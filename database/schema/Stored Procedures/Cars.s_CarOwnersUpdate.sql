SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarOwnersUpdate]
  @ProfitRatio DECIMAL(5, 2) ,
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
	
      DECLARE @CarID UNIQUEIDENTIFIER ,
        @Return INT;

    END;
	
    BEGIN --Set info
	    
      SELECT TOP ( 1 )
              @CarID = s.CarID
      FROM    Cars.t_CarOwners AS s
      WHERE   s.ID = @ID;

    END;

      BEGIN --Insert

        UPDATE  Cars.t_CarOwners
        SET     ProfitRatio = @ProfitRatio
        WHERE   ID = @ID;

      END;

      BEGIN --Insert t_CarMoving

        SET @Return = -1;

        INSERT  INTO Cars.t_CarMoving
                ( UserID ,
                  SectionID ,
                  EventIs ,
                  EventType ,
                  ComputerIP ,
                  Computer ,
                  ComputerAccount
                )
        VALUES  ( @UserID ,
                  @CarID ,
                  @Event ,
                  @EventType ,
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

      RETURN  @Return;

    END CATCH;

  END;






GO

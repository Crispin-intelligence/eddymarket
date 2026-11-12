SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_StreetInsert]
  @Name NVARCHAR(MAX) ,
  @StatesID UNIQUEIDENTIFIER ,
  @RegionID UNIQUEIDENTIFIER ,
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

      DECLARE @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Location.t_Street
              ( ID ,
                Name ,
                DescriptionIs ,
                StatesID ,
                StatesIs ,
                RegionID ,
                RegionIs
              )
      VALUES  ( @ID ,
                @Name ,
                @DescriptionIs ,
                @StatesID ,
                Location.f_StatesGetName(@StatesID) ,
                @RegionID ,
                Location.f_RegionGetName(@RegionID)
              );

      UPDATE  Location.t_Street
      SET     SearchText = Location.f_StreetSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Location.t_StreetMoving
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

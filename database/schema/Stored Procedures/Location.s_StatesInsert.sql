SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_StatesInsert]
  @Name NVARCHAR(MAX) ,
  @RegionIs NVARCHAR(MAX) ,
  @Street NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @EventBase NVARCHAR(MAX) ,
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

      DECLARE @RegionID UNIQUEIDENTIFIER = NEWID() ,
        @StreetID UNIQUEIDENTIFIER = NEWID() ,
        @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Location.t_States
              ( ID ,
                Name ,
                DescriptionIs ,
                RegionC ,
                StreetC
              )
      VALUES  ( @ID ,
                @Name ,
                @DescriptionIs ,
                1 ,
                1
              );

      UPDATE  Location.t_States
      SET     SearchText = Location.f_StatesSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert Region

      INSERT  INTO Location.t_Region
              ( ID, Name, StatesID, StatesIs )
      VALUES  ( @RegionID, @RegionIs, @ID, @Name );
	  
      UPDATE  Location.t_Region
      SET     SearchText = Location.f_RegionSearchTextGet(ID)
      WHERE   ID = @RegionID;
	  
    END;

    BEGIN --Insert Street

      INSERT  INTO Location.t_Street
              ( ID ,
                Name ,
                StatesID ,
                StatesIs ,
                RegionID ,
                RegionIs
              )
      VALUES  ( @StreetID ,
                @Street ,
                @ID ,
                @Name ,
                @RegionID ,
                @RegionIs
              );
	  
      UPDATE  Location.t_Street
      SET     SearchText = Location.f_StreetSearchTextGet(ID)
      WHERE   ID = @StreetID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Location.t_StatesMoving
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

    BEGIN --Insert event Region

      INSERT  INTO Location.t_RegionMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @RegionID ,
                @EventBase + @RegionIs ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    BEGIN --Insert event Street

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
                @StreetID ,
                @EventBase + @Street ,
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

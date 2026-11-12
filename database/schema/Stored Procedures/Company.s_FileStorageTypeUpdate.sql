SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_FileStorageTypeUpdate]
  @Name NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
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

      DECLARE @Return INT ,
        @NameOld NVARCHAR(450);

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Company.t_FileStorageType AS s
      WHERE   s.ID = @ID
      ORDER BY s.DateCreate;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Company.t_FileStorageType
      SET     Name = @Name ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_FileStorageTypeMoving
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
                1 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix Name

      UPDATE  Company.t_FileStorage
      SET     TypeIs = @Name
      WHERE   TypeIsID = @ID;

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

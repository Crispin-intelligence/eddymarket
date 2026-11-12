SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_FileStorageUpdateWithFileContent]
  @Name NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @FileContent VARBINARY(MAX) ,
  @TypeIsID UNIQUEIDENTIFIER ,
  @FileExtension NVARCHAR(MAX) ,
  @FileNameIs NVARCHAR(MAX) ,
  @Size DECIMAL(38, 7) ,
  @ExpirationDate DATE ,
  @NotificationAR NVARCHAR(MAX) ,
  @NotificationEN NVARCHAR(MAX) ,
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
      FROM    Company.t_FileStorage AS s
      WHERE   s.ID = @ID
      ORDER BY s.DateCreate;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Company.t_FileStorage
      SET     Name = @Name ,
              DescriptionIs = @DescriptionIs ,
              FileContent = @FileContent ,
              TypeIsID = @TypeIsID ,
              TypeIs = Company.f_FileStorageTypeGetName(@TypeIsID) ,
              FileExtension = @FileExtension ,
              FileNameIs = @FileNameIs ,
              Size = @Size ,
              SizeF = Calculation.SetFormatSize(@Size, N'Bytes') ,
              ExpirationDate = @ExpirationDate ,
              StopNotification = CAST(IIF(@ExpirationDate = CAST(GETDATE() AS DATE), 0, 1) AS BIT)
      WHERE   ID = @ID;

    END;

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix Name

      UPDATE  Company.t_FileStorageLinked
      SET     FileStorage = @Name
      WHERE   FileStorageID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_FileStorageMoving
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

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;








GO

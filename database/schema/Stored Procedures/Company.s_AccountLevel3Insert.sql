SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountLevel3Insert]
  @Level2ID UNIQUEIDENTIFIER ,
  @NumberIs BIGINT ,
  @Name NVARCHAR(450) ,
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

      INSERT  INTO Company.t_AccountLevel3
              ( ID ,
                Level2ID ,
                Level2 ,
                NumberIs ,
                NumberF ,
                NumberNet ,
                Name ,
                DescriptionIs
              )
      VALUES  ( @ID ,
                @Level2ID ,
                Company.f_AccountLevel2GetName(@Level2ID) ,
                @NumberIs ,
                FORMAT(@NumberIs, '0') ,
                SUBSTRING(FORMAT(@NumberIs, '0'), 4, 2) ,
                @Name ,
                @DescriptionIs
              );

      UPDATE  Company.t_AccountLevel3
      SET     SearchText = Company.f_AccountLevel3SearchTextGet(ID)
      WHERE   ID = @ID;
      
    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_AccountMoving
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

    COMMIT TRAN;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;








GO

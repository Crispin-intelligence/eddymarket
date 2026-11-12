SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Users].[s_UserUpdateUserInterfaceType]
  @UserInterfaceType TINYINT ,
  @AccountBoxID UNIQUEIDENTIFIER ,
  @AccountBoxLLID UNIQUEIDENTIFIER ,
  @AccountBoxEuroID UNIQUEIDENTIFIER ,
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

      DECLARE @Return INT;

    END;

    BEGIN --Insert

      UPDATE  Users.t_User
      SET     UserInterfaceType = @UserInterfaceType ,
              AccountBoxID = @AccountBoxID ,
              AccountBoxName = Company.f_AccountGetName(@AccountBoxID) ,
              AccountBoxNumberF = Company.f_AccountGetNumberF(@AccountBoxID) ,
              AccountBoxLLID = @AccountBoxLLID ,
              AccountBoxLLName = Company.f_AccountGetName(@AccountBoxLLID) ,
              AccountBoxLLNumberF = Company.f_AccountGetNumberF(@AccountBoxLLID) ,
              AccountBoxEuroID = @AccountBoxEuroID ,
              AccountBoxEuroName = Company.f_AccountGetName(@AccountBoxEuroID) ,
              AccountBoxEuroNumberF = Company.f_AccountGetNumberF(@AccountBoxEuroID)
      WHERE   ID = @ID;
    
      UPDATE  Users.t_User
      SET     SearchText = Users.f_UserSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Users.t_UserMoving
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

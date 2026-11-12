SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Users].[s_UserUpdate]
  @Name NVARCHAR(450) ,
  @PasswordIs NVARCHAR(MAX) ,
  @ChangePasswordOnLogin BIT ,
  @PermissionID UNIQUEIDENTIFIER ,
  @UserInterfaceType TINYINT ,
  @AccountBoxID UNIQUEIDENTIFIER ,
  @AccountBoxLLID UNIQUEIDENTIFIER ,
  @AccountBoxEuroID UNIQUEIDENTIFIER ,
  @WorkFullTime BIT ,
  @BeginWork TIME(7) ,
  @EndWork TIME(7) ,
  @TemporaryUse BIT ,
  @TemporaryDate DATE ,
  @ImageIs IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
  @IsSyncImage BIT ,
  @Spying BIT ,
  @SpyingEverySec INT ,
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
        @NameOld NVARCHAR(450);

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Users.t_User AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      UPDATE  Users.t_User
      SET     Name = @Name ,
              PasswordIs = @PasswordIs ,
              ChangePasswordOnLogin = @ChangePasswordOnLogin ,
              PermissionID = @PermissionID ,
              PermissionIs = Users.f_PermissionGetName(@PermissionID) ,
              UserInterfaceType = @UserInterfaceType ,
              AccountBoxID = @AccountBoxID ,
              AccountBoxName = Company.f_AccountGetName(@AccountBoxID) ,
              AccountBoxNumberF = Company.f_AccountGetNumberF(@AccountBoxID) ,
              AccountBoxLLID = @AccountBoxLLID ,
              AccountBoxLLName = Company.f_AccountGetName(@AccountBoxLLID) ,
              AccountBoxLLNumberF = Company.f_AccountGetNumberF(@AccountBoxLLID) ,
              AccountBoxEuroID = @AccountBoxEuroID ,
              AccountBoxEuroName = Company.f_AccountGetName(@AccountBoxEuroID) ,
              AccountBoxEuroNumberF = Company.f_AccountGetNumberF(@AccountBoxEuroID) ,
              WorkFullTime = @WorkFullTime ,
              BeginWork = @BeginWork ,
              BeginWorkF = FORMAT(CAST(@BeginWork AS DATETIME), 'hh:mm tt', 'ar-lb') ,
              EndWork = @EndWork ,
              EndWorkF = FORMAT(CAST(@EndWork AS DATETIME), 'hh:mm tt', 'ar-lb') ,
              TemporaryUse = @TemporaryUse ,
              TemporaryDate = @TemporaryDate ,
              ImageIs = @ImageIs ,
              ImagePath = @ImagePath ,
              Spying = @Spying ,
              SpyingEverySec = @SpyingEverySec ,
              IsSyncImage = @IsSyncImage
      WHERE   ID = @ID;

    END;
	        
    BEGIN --Delete t_AccountUserBlocked

      DELETE  FROM Company.t_AccountUserBlocked
      WHERE   AccountID = @AccountBoxID
              AND UserID = @ID;

    END;

    BEGIN --Rebuilding Statistics Account

      UPDATE  Company.t_Account
      SET     UserBlockedC = ( SELECT COUNT(*)
                               FROM   Company.t_AccountUserBlocked AS s
                               WHERE  s.AccountID = t_Account.ID
                             ) ,
              UsersNames = Alls.f_FixXML(( SELECT ', ' + t1.Name AS [text()]
                                           FROM   Company.t_AccountUserBlocked AS t
                                           LEFT JOIN Users.t_User AS t1 ON t1.ID = t.UserID
                                           WHERE  t.AccountID = t_Account.ID
                                         FOR
                                           XML PATH('')
                                         ))
      WHERE   ID = @AccountBoxID;

    END;

    BEGIN --Rebuilding Statistics t_User

      UPDATE  Users.t_User
      SET     AccountBlockedC = ( SELECT  COUNT(*)
                                  FROM    Company.t_AccountUserBlocked AS s
                                  WHERE   s.UserID = t_User.ID
                                ) ,
              AccountNames = Alls.f_FixXML(( SELECT ', ' + t1.Name AS [text()]
                                             FROM   Company.t_AccountUserBlocked AS t
                                             LEFT JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
                                             WHERE  t.UserID = t_User.ID
                                           FOR
                                             XML PATH('')
                                           ))
      WHERE   ID = @UserID;
    
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
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix Name

      UPDATE  Users.t_UserLogin
      SET     UserIs = @Name
      WHERE   UserID = @ID;

      UPDATE  Company.t_AccountUserBlocked
      SET     UserIs = @Name
      WHERE   UserID = @ID;

      UPDATE  Company.t_WarehouseUser
      SET     UserIs = @Name
      WHERE   UserID = @ID;

      UPDATE  Invoices.t_Purchasing
      SET     UserIs = @Name
      WHERE   UserID = @ID;

      UPDATE  Transactions.t_Transaction
      SET     UserIs = @Name
      WHERE   UserID = @ID;

      BEGIN --Fix t_Transfer

        UPDATE  Invoices.t_Transfer
        SET     UserIs = @Name
        WHERE   UserID = @ID;

        UPDATE  Invoices.t_TransferAwaited
        SET     UserIs = @Name
        WHERE   UserID = @ID;

      END;

      BEGIN --Fix t_CloseBox

        UPDATE  Company.t_CloseBox
        SET     FromUser = @Name
        WHERE   FromUserID = @ID;

        UPDATE  Company.t_CloseBox
        SET     ToUser = @Name
        WHERE   ToUserID = @ID;

      END;

      BEGIN --Fix t_Expense

        UPDATE  Company.t_Expense
        SET     UserIs = @Name
        WHERE   UserID = @ID;

      END;

      BEGIN --Fix t_OpenBox

        UPDATE  Company.t_OpenBox
        SET     UserIs = @Name
        WHERE   UserID = @ID;

      END;

      BEGIN --Fix t_StockTake

        UPDATE  Items.t_StockTake
        SET     UserIs = @Name
        WHERE   UserID = @ID;

      END;

      BEGIN --Fix t_ItemSharedMaterial

        UPDATE  Items.t_ItemSharedMaterial
        SET     CreateBy = @Name
        WHERE   CreateByID = @ID;

      END;

      BEGIN --Fix t_TransactionQuickStatement

        UPDATE  Transactions.t_TransactionQuickStatement
        SET     CreateBy = @Name
        WHERE   CreateByID = @ID;

      END;
	  	  
      BEGIN --Fix t_GymSubscription

        UPDATE  Gym.t_GymSubscription
        SET     UserIs = @Name
        WHERE   UserID = @ID;

        UPDATE  Gym.t_GymSubscriptionHistory
        SET     UserIs = @Name
        WHERE   UserID = @ID;
		  		  
        UPDATE  Gym.t_GymSubscriptionDeleted
        SET     UserIs = @Name
        WHERE   UserID = @ID;

      END;
  
      BEGIN --Fix t_CarExpense

        UPDATE  Cars.t_CarExpense
        SET     ByUser = @Name
        WHERE   ByUserID = @ID;

      END;

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

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Users].[s_UserInsert]
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

      DECLARE @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Users.t_User
              ( ID ,
                Name ,
                IsAdmin ,
                PasswordIs ,
                ChangePasswordOnLogin ,
                PermissionID ,
                PermissionIs ,
                UserInterfaceType ,
                AccountBoxID ,
                AccountBoxName ,
                AccountBoxNumberF ,
                AccountBoxLLID ,
                AccountBoxLLName ,
                AccountBoxLLNumberF ,
                AccountBoxEuroID ,
                AccountBoxEuroName ,
                AccountBoxEuroNumberF ,
                WorkFullTime ,
                BeginWork ,
                BeginWorkF ,
                EndWork ,
                EndWorkF ,
                TemporaryUse ,
                TemporaryDate ,
                ImageIs ,
                ImagePath ,
                IsSyncImage ,
                Spying ,
                SpyingEverySec
              )
      VALUES  ( @ID ,
                @Name ,
                0 ,
                @PasswordIs ,
                @ChangePasswordOnLogin ,
                @PermissionID ,
                Users.f_PermissionGetName(@PermissionID) ,
                @UserInterfaceType ,
                @AccountBoxID ,
                Company.f_AccountGetName(@AccountBoxID) ,
                Company.f_AccountGetNumberF(@AccountBoxID) ,
                @AccountBoxLLID ,
                Company.f_AccountGetName(@AccountBoxLLID) ,
                Company.f_AccountGetNumberF(@AccountBoxLLID) ,
                @AccountBoxEuroID ,
                Company.f_AccountGetName(@AccountBoxEuroID) ,
                Company.f_AccountGetNumberF(@AccountBoxEuroID) ,
                @WorkFullTime ,
                @BeginWork ,
                FORMAT(CAST(@BeginWork AS DATETIME), 'hh:mm tt', 'ar-lb') ,
                @EndWork ,
                FORMAT(CAST(@EndWork AS DATETIME), 'hh:mm tt', 'ar-lb') ,
                @TemporaryUse ,
                @TemporaryDate ,
                @ImageIs ,
                @ImagePath ,
                IIF(@ImagePath = N'', 0, 1) ,
                @Spying ,
                @SpyingEverySec
              );

    END;
     
    BEGIN --Insert t_WarehouseUser

      INSERT  INTO Company.t_WarehouseUser
              ( WarehouseID ,
                Warehouse ,
                UserID ,
                UserIs 
              )
      SELECT  t.ID ,
              t.Name ,
              @ID ,
              @Name
      FROM    Company.t_WareHouse AS t;

    END;

    BEGIN --Rebuilding Statistics t_WareHouse

      UPDATE  Company.t_WareHouse
      SET     UserC = ( SELECT  COUNT(*)
                        FROM    Company.t_WarehouseUser AS s
                        WHERE   s.WarehouseID = t_WareHouse.ID
                      ) ,
              UsersNames = Alls.f_FixXML(( SELECT ', ' + t1.Name AS [text()]
                                           FROM   Company.t_WarehouseUser AS t
                                           LEFT JOIN Users.t_User AS t1 ON t1.ID = t.UserID
                                           WHERE  t.WarehouseID = t_WareHouse.ID
                                         FOR
                                           XML PATH('')
                                         ));

    END;
        
    BEGIN --Insert t_AccountUserBlocked

      INSERT  INTO Company.t_AccountUserBlocked
              ( AccountID ,
                Account ,
                UserID ,
                UserIs ,
                CanUse 
              )
      SELECT  t.ID ,
              t.Name ,
              @ID ,
              @Name ,
              0
      FROM    Company.t_Account AS t
      WHERE   t.NumberIs BETWEEN 5310100000 AND 5310199999
              AND t.ID <> @AccountBoxID;

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
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   Company.t_Account AS s
                       WHERE  s.NumberIs BETWEEN 5310100000 AND 5310199999
                              AND s.ID <> @AccountBoxID );

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

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;
GO

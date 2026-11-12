SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_AccountUserBlockedCopy]
  @FromUserID UNIQUEIDENTIFIER ,
  @ToUserID UNIQUEIDENTIFIER ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --DECLARE

      DECLARE @ToUser NVARCHAR(MAX) = Users.f_UserGetName(@ToUserID) ,
        @UserAccountBoxID UNIQUEIDENTIFIER ,
        @Return INT= 0;

    END;

    BEGIN --Set info
    
      SELECT TOP ( 1 )
              @UserAccountBoxID = s.AccountBoxID
      FROM    Users.t_User AS s
      WHERE   s.ID = @ToUserID;

    END;

    BEGIN --Delete old accounts
    
      DELETE  FROM Company.t_AccountUserBlocked
      WHERE   UserID = @ToUserID;

    END;

    BEGIN --Insert Account

      INSERT  INTO Company.t_AccountUserBlocked
              ( AccountID ,
                Account ,
                UserID ,
                UserIs ,
                CanUse
              )
      SELECT  s.AccountID ,
              s.Account ,
              @ToUserID ,
              @ToUser ,
              s.CanUse
      FROM    Company.t_AccountUserBlocked AS s
      WHERE   s.UserID = @FromUserID
              AND s.AccountID <> @UserAccountBoxID;

    END;

    BEGIN --Rebuilding statistics Account

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
                       FROM   Company.t_AccountUserBlocked AS s
                       WHERE  s.UserID = @ToUserID );

    END;

    BEGIN --Rebuilding statistics User

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
      WHERE   ID = @ToUserID;

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
      SELECT  @UserID ,
              s.ID ,
              @Event + @ToUser ,
              1 ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    Company.t_Account AS s
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   Company.t_AccountUserBlocked AS s
                       WHERE  s.UserID = @ToUserID );

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

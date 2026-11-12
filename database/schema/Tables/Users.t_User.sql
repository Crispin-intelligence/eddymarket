CREATE TABLE [Users].[t_User]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_User_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_tbl_User_UserName] DEFAULT ('admin'),
[IsAdmin] [bit] NOT NULL CONSTRAINT [DF_t_User_UserAdmin] DEFAULT ((1)),
[PasswordIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_tbl_User_UserPassword] DEFAULT ('0000'),
[ChangePasswordOnLogin] [bit] NOT NULL CONSTRAINT [DF_t_User_UserFirstLoginChangePassword] DEFAULT ((0)),
[PermissionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_User_PermissionID] DEFAULT ([Users].[f_PermissionGetFirstID]()),
[PermissionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_PermissionIs] DEFAULT ([Users].[f_PermissionGetFirstName]()),
[UserInterfaceType] [tinyint] NOT NULL CONSTRAINT [DF_t_User_UserInterfaceType] DEFAULT ((0)),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_User_AccountBoxID] DEFAULT ([Company].[f_AccountBoxGetFirstID]()),
[AccountBoxName] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_AccountBoxName] DEFAULT ([Company].[f_AccountBoxGetFirstName]()),
[AccountBoxNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_AccountBoxNumberF] DEFAULT ([Company].[f_AccountBoxGetFirstNumberF]()),
[AccountBoxLLID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_User_AccountBoxLLID] DEFAULT ([Company].[f_AccountBoxGetFirstID]()),
[AccountBoxLLName] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_AccountBoxLLName] DEFAULT ([Company].[f_AccountBoxGetFirstName]()),
[AccountBoxLLNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_AccountBoxLLNumberF] DEFAULT ([Company].[f_AccountBoxGetFirstNumberF]()),
[AccountBoxEuroID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_User_AccountBoxEuroID] DEFAULT ([Company].[f_AccountBoxGetFirstID]()),
[AccountBoxEuroName] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_AccountBoxEuroName] DEFAULT ([Company].[f_AccountBoxGetFirstName]()),
[AccountBoxEuroNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_AccountBoxEuroNumberF] DEFAULT ([Company].[f_AccountBoxGetFirstNumberF]()),
[WorkFullTime] [bit] NOT NULL CONSTRAINT [DF_t_User_WorkFullTime] DEFAULT ((1)),
[BeginWork] [time] NOT NULL CONSTRAINT [DF_t_User_UserBeginWork] DEFAULT (getdate()),
[BeginWorkF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_BeginWorkF] DEFAULT (format(getdate(),'hh:mm tt','ar-lb')),
[EndWork] [time] NOT NULL CONSTRAINT [DF_t_User_UserEndWork] DEFAULT (CONVERT([datetime],getdate()+(0.5),(0))),
[EndWorkF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_EndWorkF] DEFAULT (format(CONVERT([datetime],getdate()+(0.5),(0)),'hh:mm tt','ar-lb')),
[TemporaryUse] [bit] NOT NULL CONSTRAINT [DF_t_User_UserTemporaryUse] DEFAULT ((0)),
[TemporaryDate] [date] NOT NULL CONSTRAINT [DF_t_User_UserDateEndOfUse] DEFAULT (getdate()),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_User_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImagePath] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_ImagePath] DEFAULT (''),
[Spying] [bit] NOT NULL CONSTRAINT [DF_t_User_Spying] DEFAULT ((0)),
[SpyingEverySec] [int] NOT NULL CONSTRAINT [DF_t_User_InEverySec] DEFAULT ((1)),
[IsOnline] [bit] NOT NULL CONSTRAINT [DF_t_User_IsOnline] DEFAULT ((0)),
[IsEnable] [bit] NOT NULL CONSTRAINT [DF_t_User_IsEnable] DEFAULT ((1)),
[HoursIs] [float] NOT NULL CONSTRAINT [DF_t_User_HoursIs] DEFAULT ((0)),
[WorkTime] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_WorkTime] DEFAULT (''),
[LoginC] [bigint] NOT NULL CONSTRAINT [DF_t_User_LoginC] DEFAULT ((0)),
[AccountBlockedC] [int] NOT NULL CONSTRAINT [DF_t_User_AccountBlockedC] DEFAULT ((0)),
[AccountNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_AccountNames] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_User_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_User_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_User_IsSync] DEFAULT ((0)),
[IsSyncImage] [bit] NOT NULL CONSTRAINT [DF_t_User_IsSyncImage] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_User_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Users].[tr_User] ON [Users].[t_User]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Users.t_User
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_User.ID );

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            1 ,
            'user'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            1 ,
            'user'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, UserIs, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaUser, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Users].[t_User] ADD CONSTRAINT [PK_t_User] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_UserName_Name] ON [Users].[t_User] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Users].[t_User] ADD CONSTRAINT [AccountBoxEuroKeyUser] FOREIGN KEY ([AccountBoxEuroID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Users].[t_User] ADD CONSTRAINT [AccountBoxKeyUser] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Users].[t_User] ADD CONSTRAINT [AccountBoxLLKeyUser] FOREIGN KEY ([AccountBoxLLID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Users].[t_User] ADD CONSTRAINT [PermissionKeyUser] FOREIGN KEY ([PermissionID]) REFERENCES [Users].[t_Permission] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'normal = 0
pointOfSale = 1
pointOfSaleTouchScreen = 2', 'SCHEMA', N'Users', 'TABLE', N't_User', 'COLUMN', N'UserInterfaceType'
GO

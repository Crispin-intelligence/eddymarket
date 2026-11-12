CREATE TABLE [Company].[t_AccountUserBlocked]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountUserBlocked_ID] DEFAULT (newsequentialid()),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountUserBlocked_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountUserBlocked_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountUserBlocked_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountUserBlocked_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[CanUse] [bit] NOT NULL CONSTRAINT [DF_t_AccountUserBlocked_CanUse] DEFAULT ((1)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_AccountUserBlocked_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_AccountUserBlocked_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_AccountUserBlocked]
ON [Company].[t_AccountUserBlocked]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Account, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, UserIs, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaUser, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Company].[t_AccountUserBlocked] ADD CONSTRAINT [PK_t_AccountUserBlocked] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_AccountUserBlocked_AccountID_UserID] ON [Company].[t_AccountUserBlocked] ([AccountID], [UserID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_AccountUserBlocked] ADD CONSTRAINT [AccountKeyAccountUserBlocked] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_AccountUserBlocked] ADD CONSTRAINT [UserKeyAccountUserBlocked] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO

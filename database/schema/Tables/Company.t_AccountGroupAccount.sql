CREATE TABLE [Company].[t_AccountGroupAccount]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountGroupAccount_ID] DEFAULT (newsequentialid()),
[AccountGroupID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountGroupAccount_AccountGroupID] DEFAULT ([Company].[f_AccountGroupGetFirstID]()),
[AccountGroup] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountGroupAccount_AccountGroup] DEFAULT ([Company].[f_AccountGroupGetFirstName]()),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountGroupAccount_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountGroupAccount_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_AccountGroupAccount_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_AccountGroupAccount_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_AccountGroupAccount]
ON [Company].[t_AccountGroupAccount]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Account, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;

GO
ALTER TABLE [Company].[t_AccountGroupAccount] ADD CONSTRAINT [PK_t_AccountGroupAccount] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_AccountGroupAccount_AccountGroupIDAndAccountID] ON [Company].[t_AccountGroupAccount] ([AccountGroupID], [AccountID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_AccountGroupAccount] ADD CONSTRAINT [AccountGroupKeyAccountGroupAccount] FOREIGN KEY ([AccountGroupID]) REFERENCES [Company].[t_AccountGroup] ([ID])
GO
ALTER TABLE [Company].[t_AccountGroupAccount] ADD CONSTRAINT [AccountKeyAccountGroupAccount] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO

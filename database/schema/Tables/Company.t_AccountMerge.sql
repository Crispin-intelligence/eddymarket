CREATE TABLE [Company].[t_AccountMerge]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountMerge_ID] DEFAULT (newsequentialid()),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountMerge_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountMerge_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountNumber] [bigint] NOT NULL CONSTRAINT [DF_t_AccountMerge_AccountNumber] DEFAULT ([Company].[f_AccountGetFirstNumber]()),
[AccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountMerge_AccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[AccountIDWith] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountMerge_AccountIDWith] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountWith] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountMerge_AccountWith] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountWithNumber] [bigint] NOT NULL CONSTRAINT [DF_t_AccountMerge_AccountWithNumber] DEFAULT ([Company].[f_AccountGetFirstNumber]()),
[AccountWithNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountMerge_AccountWithNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_AccountMerge_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_AccountMerge_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_AccountMerge]
ON [Company].[t_AccountMerge]
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
ALTER TABLE [Company].[t_AccountMerge] ADD CONSTRAINT [CK_t_AccountMerge_AccountID] CHECK (([AccountID]<>[AccountIDWith]))
GO
ALTER TABLE [Company].[t_AccountMerge] ADD CONSTRAINT [PK_t_AccountMerge] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_AccountMerge] ADD CONSTRAINT [AccountKeyAccountMerge] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_AccountMerge] ADD CONSTRAINT [AccountWithKeyAccountMerge] FOREIGN KEY ([AccountIDWith]) REFERENCES [Company].[t_Account] ([ID])
GO

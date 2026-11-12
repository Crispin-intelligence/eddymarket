CREATE TABLE [Company].[t_AccountGroupRange]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountGroupRange_ID] DEFAULT (newsequentialid()),
[AccountGroupID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountGroupRange_AccountGroupID] DEFAULT ([Company].[f_AccountGroupGetFirstID]()),
[AccountGroup] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountGroupRange_AccountGroup] DEFAULT ([Company].[f_AccountGroupGetFirstName]()),
[FromNumber] [bigint] NOT NULL CONSTRAINT [DF_t_AccountGroupRange_FromNumber] DEFAULT ((4010100000.)),
[ToNumber] [bigint] NOT NULL CONSTRAINT [DF_t_AccountGroupRange_ToNumber] DEFAULT ((4010199999.)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_AccountGroupRange_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_AccountGroupRange_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_AccountGroupRange]
ON [Company].[t_AccountGroupRange]
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
ALTER TABLE [Company].[t_AccountGroupRange] ADD CONSTRAINT [PK_t_AccountGroupRange] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_AccountGroupRange] ADD CONSTRAINT [AccountGroupKeyAccountGroupRange] FOREIGN KEY ([AccountGroupID]) REFERENCES [Company].[t_AccountGroup] ([ID])
GO

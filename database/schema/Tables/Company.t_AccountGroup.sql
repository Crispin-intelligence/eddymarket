CREATE TABLE [Company].[t_AccountGroup]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountGroup_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountGroup_Name] DEFAULT ('-'),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountGroup_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountGroup_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_AccountGroup_TypeIs] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountGroup_DescriptionIs] DEFAULT (''),
[AccountC] [int] NOT NULL CONSTRAINT [DF_t_AccountGroup_AccountC] DEFAULT ((0)),
[AccountNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountGroup_AccountNames] DEFAULT (''),
[RangeC] [int] NOT NULL CONSTRAINT [DF_t_AccountGroup_RangeC] DEFAULT ((0)),
[RangeNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountGroup_RangeNames] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_AccountGroup_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_AccountGroup_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_AccountGroup]
ON [Company].[t_AccountGroup]
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
ALTER TABLE [Company].[t_AccountGroup] ADD CONSTRAINT [CK_t_AccountGroup_Name] CHECK (([Name]<>N''))
GO
ALTER TABLE [Company].[t_AccountGroup] ADD CONSTRAINT [PK_t_AccountGroup] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_AccountGroup] ADD CONSTRAINT [CurrencyKeyAccountGroup] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Daily = 0
Monthly = 1
Yearly = 2', 'SCHEMA', N'Company', 'TABLE', N't_AccountGroup', 'COLUMN', N'TypeIs'
GO
